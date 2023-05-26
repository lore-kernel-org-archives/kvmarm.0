Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371C22CA9
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 21:37:11 +0000 (UTC)
Date: Fri, 26 May 2023 21:37:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685137029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFmfZJ9XSBvihraEvyzSKBtHQpCcMvW1SpatpSEYiEE=;
	b=mAQWhVuBWTZ2vUp9QXlpaQmgvIpPn7WZKHBChPEYdJXqisi9FB5bGReorOWP3/umm0nQgh
	wpQH14L8SKVxqsuP3iyV7hBqWuSQBglt0VRFRwsGr17PN/YnZH5MVM09zmdKOvND3xyqnF
	qAM4htNt1/pFWDuDRChhDvZDdJZSaHM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v10 4/5] KVM: arm64: Reuse fields of sys_reg_desc for
 idreg
Message-ID: <ZHEmgPAK59Wh/jv/@linux.dev>
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-5-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522221835.957419-5-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Jing,

On Mon, May 22, 2023 at 10:18:34PM +0000, Jing Zhang wrote:
> Since reset() and val are not used for idreg in sys_reg_desc, they would
> be used with other purposes for idregs.
> The callback reset() would be used to return KVM sanitised id register
> values. The u64 val would be used as mask for writable fields in idregs.
> Only bits with 1 in val are writable from userspace.

The tense of the changelog is wrong (should be in an imperative mood).
Maybe something like:

  sys_reg_desc::{reset, val} are presently unused for ID register
  descriptors. Repurpose these fields to support user-configurable ID
  registers.

  Use the ::reset() function pointer to return the sanitised value of a
  given ID register, optionally with KVM-specific feature sanitisation.
  Additionally, keep a mask of writable register fields in ::val.

> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 101 +++++++++++++++++++++++++++-----------
>  arch/arm64/kvm/sys_regs.h |  15 ++++--
>  2 files changed, 82 insertions(+), 34 deletions(-)
> 

[...]

> +/*
> + * Since reset() callback and field val are not used for idregs, they will be
> + * used for specific purposes for idregs.
> + * The reset() would return KVM sanitised register value. The value would be the
> + * same as the host kernel sanitised value if there is no KVM sanitisation.
> + * The val would be used as a mask indicating writable fields for the idreg.
> + * Only bits with 1 are writable from userspace. This mask might not be
> + * necessary in the future whenever all ID registers are enabled as writable
> + * from userspace.
> + */
> +
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
> @@ -1751,6 +1788,8 @@ static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = id_visibility,		\
> +	.reset = general_read_kvm_sanitised_reg,\
> +	.val = 0,				\

I generally think unions are more trouble than they're worth, but it
might make sense to throw the fields with dual meaning into one, like

  struct sys_reg_desc {

  	[...]
	union {
		struct {
			void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
			u64 val;
		};
		struct {
			u64 (*read_sanitised)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *);
			u64 mask;
		};
	};
  }

You could then avoid repainting the world to handle ->reset() returning
a value and usage of the fields in an id register context become a bit
more self-documenting. And you get to play with fire while you do it!

Let's see if the other side of the pond agrees with my bikeshedding...

-- 
Thanks,
Oliver

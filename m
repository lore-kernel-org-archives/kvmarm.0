Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0C3F4FD
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 10:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684232777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A8RPDB5oCUZPol53GuFRKa1PDnfifaD9ISAfpPJWqOU=;
	b=RHEGcnzFpWEMegqM38KS4H7poih+ipa7fJeh6y1nScEdIE+d/rMC/JU8b2ny8d/v1dV5d4
	NoXK/mshZaxG2DTq2FGEdds3I1ZWzaH8emhjhOV0ZVP1LMz588cD+Bp1u7bNPLe/b8IHfx
	HYAjC89Pm9mtNlMCYpubrirqanM12SY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-M7Zkyq0vMxez3ve1Zok7Lw-1; Tue, 16 May 2023 06:26:13 -0400
X-MC-Unique: M7Zkyq0vMxez3ve1Zok7Lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B31E785A5B1;
	Tue, 16 May 2023 10:26:12 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70AA740C206F;
	Tue, 16 May 2023 10:26:12 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>, KVMARM
 <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 James Morse <james.morse@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang
 <jingzhangos@google.com>
Subject: Re: [PATCH v8 5/6] KVM: arm64: Reuse fields of sys_reg_desc for idreg
In-Reply-To: <20230503171618.2020461-6-jingzhangos@google.com>
Organization: Red Hat GmbH
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <20230503171618.2020461-6-jingzhangos@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Tue, 16 May 2023 12:26:11 +0200
Message-ID: <87ilcsh8sc.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

On Wed, May 03 2023, Jing Zhang <jingzhangos@google.com> wrote:

> Since reset() and val are not used for idreg in sys_reg_desc, they would
> be used with other purposes for idregs.
> The callback reset() would be used to return KVM sanitised id register
> values. The u64 val would be used as mask for writable fields in idregs.
> Only bits with 1 in val are writable from userspace.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/id_regs.c  | 44 +++++++++++++++++++----------
>  arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++------------
>  arch/arm64/kvm/sys_regs.h | 10 ++++---
>  3 files changed, 77 insertions(+), 36 deletions(-)
>

(...)

> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index e88fd77309b2..21869319f6e1 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -65,12 +65,12 @@ struct sys_reg_desc {
>  		       const struct sys_reg_desc *);
>  
>  	/* Initialization for vcpu. */

Maybe be a bit more verbose here?

/* Initialization for vcpu. Return initialized value, or KVM sanitized
   value for id registers. */

> -	void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
> +	u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
>  
>  	/* Index into sys_reg[], or 0 if we don't need to save it. */
>  	int reg;
>  
> -	/* Value (usually reset value) */
> +	/* Value (usually reset value), or write mask for idregs */
>  	u64 val;
>  
>  	/* Custom get/set_user functions, fallback to generic if NULL */


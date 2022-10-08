Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5576B7E
	for <kvmarm@lists.linux.dev>; Sat,  8 Oct 2022 03:15:07 +0000 (UTC)
Date: Sat, 8 Oct 2022 03:14:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1665198905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w536VtiSPZviNhRM1LzNsJqAcdtnkz72j6ZSuWSYzrk=;
	b=L8qFzW5Ns/GH849lEiEkf/QN0w9JqKt0EwPU4KaxnMXbRws9GU90wGetKZXLch5MbHudHm
	oULU3HiXt3869EBTLOBwIVor8Xmbh9hbgo+Q/wWoI1PPKzS1ppNcN6q0yJom5/uaWz6K4x
	06txuOFNTNzRmomT8lTxCloo7LkmlM8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kernel test robot <lkp@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	kbuild-all@lists.01.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y0DrMx0oEzXQRNqT@google.com>
References: <20221007233253.460257-1-oliver.upton@linux.dev>
 <202210081008.A9PLyQx2-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210081008.A9PLyQx2-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221008031459.RXbLksOmJw9JvKsCnOrZ0NqnKg_krA6pj3kV2Leo2Wo@z>

On Sat, Oct 08, 2022 at 11:01:44AM +0800, kernel test robot wrote:

[...]

> All warnings (new ones prefixed by >>):
> 
>    arch/arm64/kvm/hyp/nvhe/mem_protect.c: In function '__host_stage2_idmap':
> >> arch/arm64/kvm/hyp/nvhe/mem_protect.c:260:60: warning: implicit conversion from 'enum <anonymous>' to 'enum kvm_pgtable_walk_flags' [-Wenum-conversion]
>      260 |                                       prot, &host_s2_pool, false);
>          |                                                            ^~~~~
> 

Woops, this one fell through the cracks of the flagification.

--
Thanks,
Oliver

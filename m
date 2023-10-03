Received: from out-190.mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC6DDDC2
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 19:41:46 +0000 (UTC)
Date: Tue, 3 Oct 2023 19:41:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696362104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V79QyC7RXTrpI5ufqPj8jcBHkQ4sW7kYXdmUSPCuGu8=;
	b=YnsyQeZH8wtUt88iltpg5Zpl54Qzkn/eyC4ghPfONRytGTHhHRHEfbbp+Qe3BQT+EB5TZi
	bV8nfssi3YZ9lxHwt5hfiatPE1jQFjmaddKWKhpA1LOOsVPyZ5pcnT7wVRcPRlWF+fTcsR
	Mw7fn3YN+py6g6ObR8SKa0Ldj7FCcOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Jing Zhang <jingzhangos@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v10 06/12] KVM: arm64: Allow userspace to change
 ID_AA64ISAR{0-2}_EL1
Message-ID: <ZRxudJGhSe8dOiDj@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-7-oliver.upton@linux.dev>
 <80140d61-82e7-2795-409d-2cf6dc4993bc@arm.com>
 <ZQ3UaYTsZ1lVeShQ@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQ3UaYTsZ1lVeShQ@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 22, 2023 at 05:52:41PM +0000, Oliver Upton wrote:
> > Nit: it shouldn't be necessary to override BC anymore, as it was recently fixed
> > in the arm64 code:
> >   https://lore.kernel.org/linux-arm-kernel/20230912133429.2606875-1-kristina.martsenko@arm.com/
> 
> Perfect, looks like that patch should go in 6.6 too. Thanks for the fix!

Going to squash the following into the patch:

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c74920063287..179f82bd90af 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1225,10 +1225,6 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 			break;
 		}
 		break;
-	case SYS_ID_AA64ISAR2_EL1:
-		if (kvm_ftr.shift == ID_AA64ISAR2_EL1_BC_SHIFT)
-			kvm_ftr.type = FTR_LOWER_SAFE;
-		break;
 	case SYS_ID_DFR0_EL1:
 		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
 			kvm_ftr.type = FTR_LOWER_SAFE;

-- 
Thanks,
Oliver

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597723;
	b=WOFFbvoemrquI9/GrDB55WoglP5L6PhcI4HIbfooGCx43lYTD3Z6L+FEzecvvWL7usmx
	 I01D/MokdWvL6/gZWylHPb2t8wvDJ9taBru6RpCPo6lMu7RYjExA9Zdd6HUPwTsP62RfD
	 W7YW5RRTSgn18TyqE3spJ05QaFbh6XTAOZE+qt3/pAPS6n5vteBslDnUnBlmB3/BtlIv5
	 iH0M6YOHTZzcv5U0ZdRkhGu6bLl76yADTKx23FdwjbLZ4pMkiAsP649Ki+70sfyKGlCIF
	 3srwdmK2oA4uUyQ8CBao89muvjcc/cAxNaKoStDxySZYIwfUxaPv+lD/XZip2+se4RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597723;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=QVie/z0J40GiWaXqHRXPvG+NrtU10m0jzVDp6bMnZM8=;
	b=3gLg9TtJiE+CHahP45DdHi/OuY15bWAc43BemOxCA9krckT35jjGSu4xAovYmYOVtQNX
	 p3DygrXMRkSKMfnkb80qsUBHg8sCyg95JefOlDWsf7/YcffvSODdcOmEtU6C0rXRQZdfq
	 D4sPjhs+xej8JvO1o60IOJk2Sihcs6yJc0oM1PJGlpBL0/zxOnx9AHHufM/Wyk2qncdYw
	 o9t4/oSgi8ymqNPmWHBpft+3WIHsWWrvpnNoeTSsOk/iBPa3Rw+f9HAQCrGhrrjA/XPHr
	 ljdEyuZikVaohCif3+2ZG8+7qMPd1d8jc3nMPFoI9ok1g+7RFPlcMlsfrXsJ4vVfsdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dcAnQhGt;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E42606A331
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 09:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18E42606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dcAnQhGt
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9198E339;
	Wed, 25 Nov 2026 01:08:38 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 475643F86F;
	Wed, 25 Nov 2026 01:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795597721; bh=pmOn0GAQ/bIzl3yEFkQbNwWqfmhqh+tr+9j74hBF0n8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dcAnQhGtPKyESIvNebDMGfL2TrSqBtOSKEzh2om+0KBX3wkCehatasRziYTiTReSc
	 p/UUMgQHC6adqOhdOTayYPC49JWou0HCkpkyxeUkQrtwhFWHqMDagQJqtyaF2HHbmz
	 KlGBHPKyMdilzcBf8Nwd5t0/GuII1ev/VeEvtsPg=
Message-ID: <0c7c59df-69cd-40fe-830f-60c0f3cedafa@arm.com>
Date: Wed, 25 Nov 2026 09:08:36 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] KVM: arm64: Reset SP_EL1, ELR_EL1 and SPSR_EL1
 when resetting a vcpu
To: Dan Carpenter <dan@pereq.eu>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Christoffer Dall <c.dall@virtualopensystems.com>,
 Rusty Russell <rusty@rustcorp.com.au>, Marcelo Tosatti
 <mtosatti@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Eric Auger <eric.auger@redhat.com>, James Morse <james.morse@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>
Cc: Karthik Bhargavan <karthik@pereq.eu>,
 =?UTF-8?Q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org
References: <20261125-double_exception-v2-0-224689d8a764@pereq.eu>
 <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261125-double_exception-v2-2-224689d8a764@pereq.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/11/2026 06:56, Dan Carpenter wrote:
> Resetting a vcpu keeps the old values of SP_EL1, ELR_EL1 and SPSR_EL1.
> Commit e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
> changed the reset to only clear the general purpose registers, SP, PC
> and PSTATE, and later commits moved these three registers to the system
> register array without a reset value.  Commit 85d703746154 ("KVM: arm64:
> Fully zero the vcpu state on reset") fixed the FP registers and the
> 32-bit SPSRs the same commit missed, but not these three.
> 
> The impact is that the guest that boots next can read the previous
> kernel's stack pointer and exception return address.  KVM_GET_ONE_REG
> also returns the old values to userspace, and a rebooted VM doesn't
> start in the same state as a new one.
> 
> Zero them in kvm_reset_vcpu().
> 
> Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dan Carpenter <dan@pereq.eu>
> ---
>   arch/arm64/kvm/reset.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 26081d273408..9c1b42890c96 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -199,6 +199,9 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   
>   	/* Reset core registers */
>   	kvm_reset_vcpu_core(vcpu);
> +	__vcpu_assign_sys_reg(vcpu, SP_EL1, 0);
> +	__vcpu_assign_sys_reg(vcpu, ELR_EL1, 0);
> +	__vcpu_assign_sys_reg(vcpu, SPSR_EL1, 0);

nit: Please could we move these into kvm_reset_vcpu_core() where we
reset other registers ?

With that:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


>   	vcpu->mmio_needed = false;
>   
>   	/* Reset system registers */
> 


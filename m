Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0BC21B191
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753175895; cv=none; b=W5e5q32bbrFHUDhHcxwNPZGYrTn8NHaqwtseJ5qPt3TyEcxTYZnkSABpjehYX9/krqVBN7T3EWotf6I95gfFrf/GONJP0rqTJIStHlsSxENALQSgdnhnB9bW4TEfHHpru8LzuuThQg3kb6XGppp+b5ihXTrBy+pjLVbEm2dPJyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753175895; c=relaxed/simple;
	bh=hhQufx2HD4Ts5oBIe9054Ablz+7kZBZZDBYP7X7WX8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaybuvNXo6ASlVDMynnONodak4wIDLc4eS7MvulEshEExHrmV9BI+hYxqFYm2kg6ZkP6gKt+V3QdBM7yZkExJ4GjRPSJ+5Yd63hnbCr2QXhgBjPSEssRJWkYogoHI4sjjXmCHiQ81omQijxkokYtDQDYgibNZGaCmAzn3HdVPNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OTVQysmG; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OTVQysmG"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a6cdc27438so4225218f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 02:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1753175892; x=1753780692; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PHFy2ib8R7VJ1RgEKC7LoLc8P9a6wfUZ5RjA5auf7Xg=;
        b=OTVQysmGrmuif6DmNRNFif9dKjwr87E10rSElsGtt0Q8txcxiAdpyq+AdKZSS7lkso
         ut9dDjVPq9QcRNhwLbREY6Wmwo/W56qfWeR9GcdhQ5LatcJTG9szH3iaU/JU9MUE5dh/
         knE5SjzwCb9yEgRtKh/IERZGeUIZuGKGhpKRPj93EkkX/XejsrNdIbvfDbOCEtJo2mE4
         jg8iaaNDG1EpiAlZw5VqY3aypRT3IrwoKB02DVXzSts9diMuFTWlQJkPAImLVkAhIXQK
         uOC2AKVDM7yks8mNWHQRXov76OkHNTyGoYTY5EjlTs4UBHravOwHRBeyLx16Zh+aQH83
         DNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753175892; x=1753780692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHFy2ib8R7VJ1RgEKC7LoLc8P9a6wfUZ5RjA5auf7Xg=;
        b=jD6PM9MMMTrCyR31d3dJfqT16VTfGdFY7wyamKaWjE0ff1A9bh8SZaZYZsimMOK+zU
         PeohP00IaUGuHZGGvm3j/KzEA5Gxiec5FpMgXk4NJ6uHuja0hcU4yknS/NrS2mPHlv/r
         H3fzvKxzLue/cRoUsxHwabaXeKlUtXjiTR+H4eDYoe/w8sLVFDe+sAytYMjIhIQxsaxn
         vWRTRsis5GRPAsob/z0gxowhBI1ZE34urOMrppU0nongv9qNl6naunFhCxxWHzwvwceO
         M8EwQ5pHpyIyMQeyWMd54JCjNWZp4h8bB9xPXozyVyGzlX93b8ywU8CWJ/e709AAjt9Q
         WmKQ==
X-Gm-Message-State: AOJu0Yys2MfMBmpoD1otDzZZI4xP+xwNIWfG/rrMtkZgNQxAY+o9xLGe
	6B+sUGPabwB2Hab0C7cOwTxscXXhDLDgEdUpejUBD5e5oRhcPxR5MrI8d8IryXnuU1Y=
X-Gm-Gg: ASbGncsoq5FDMyzfYLeAssbBtxzUl9KcxUQ4yW21VRwGffmI6qC81eaTeq1gH4i6zqD
	nmMsnPpC/l4ABvHWM77NSeytHH/WzWE7kzskbZb1ChF4lR4XvkvopgLksK0tRCsuLwqf7lRZzYa
	JSF5GWIL8UtPYlA5LHZMTnmXYRxMRJK1x6JxVouSbSq2fG1opmkLm9op1TIx+TN9JACPhLLvUxk
	lKsDJL+lHO1XGTzllSkULOc6eCKpbHQiLYSz42zyQAKui/27+jL8gT+jIH8r6akmLRWKgCizPFY
	a7pG2teWimGNspD+c0mGGOhWptHpVAnLhp7xDUOurAD5+SAgtgAPyEjUmuU8EgSXSvL6L6s+y0K
	mYqXIfOjGfw==
X-Google-Smtp-Source: AGHT+IHQBAZgY70xI+dtP0yh6yvLOKV0BlM/uTMSPEIciqVVZwMQSsJNaHFcQVjMoLC9XYi1w0Ju7g==
X-Received: by 2002:a05:6000:2892:b0:3a4:f379:65bc with SMTP id ffacd0b85a97d-3b60e523efamr18492284f8f.40.1753175891891;
        Tue, 22 Jul 2025 02:18:11 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f15c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca48a2esm12946678f8f.51.2025.07.22.02.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 02:18:11 -0700 (PDT)
Date: Tue, 22 Jul 2025 11:18:10 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, jackabt@amazon.com
Subject: Re: [PATCH] KVM: arm64: selftest: Add standalone test checking for
 KVM's own UUID
Message-ID: <20250722-87ac9d7e0b27cf7c67a4fbd3@orel>
References: <20250721155136.892255-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721155136.892255-1-maz@kernel.org>

Hi Marc,

On Mon, Jul 21, 2025 at 04:51:36PM +0100, Marc Zyngier wrote:
> Tinkering with UUIDs is a perilious task, and the KVM UUID gets
> broken at times. In order to spot this early enough, add a selftest
> that will shout if the expected value isn't found.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20250721130558.50823-1-jackabt.amazon@gmail.com
> ---
>  tools/testing/selftests/kvm/Makefile.kvm     |  1 +
>  tools/testing/selftests/kvm/arm64/kvm-uuid.c | 67 ++++++++++++++++++++
>  2 files changed, 68 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/arm64/kvm-uuid.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index ce817a975e50a..e1eb1ba238a2a 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -167,6 +167,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_irq
>  TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
>  TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
>  TEST_GEN_PROGS_arm64 += arm64/no-vgic-v3
> +TEST_GEN_PROGS_arm64 += arm64/kvm-uuid
>  TEST_GEN_PROGS_arm64 += access_tracking_perf_test
>  TEST_GEN_PROGS_arm64 += arch_timer
>  TEST_GEN_PROGS_arm64 += coalesced_io_test
> diff --git a/tools/testing/selftests/kvm/arm64/kvm-uuid.c b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
> new file mode 100644
> index 0000000000000..89d9c8b182ae5
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/kvm-uuid.c
> @@ -0,0 +1,67 @@
> +#include <errno.h>
> +#include <linux/arm-smccc.h>
> +#include <asm/kvm.h>
> +#include <kvm_util.h>
> +
> +#include "processor.h"
> +
> +/*
> + * Do NOT redefine these constants, or try to replace them with some
> + * "common" version. They are hardcoded here to detect any potential
> + * breakage happening in the rest of the kernel.
> + *
> + * KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74
> + */
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
> +#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
> +
> +static void guest_code(void)
> +{
> +	struct arm_smccc_res res = {};
> +
> +	smccc_hvc(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
> +
> +	__GUEST_ASSERT(res.a0 != SMCCC_RET_NOT_SUPPORTED, "a0 = %lx\n", res.a0);

Should this check res.a0 == SMCCC_RET_SUCCESS instead?

> +	__GUEST_ASSERT(res.a0 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0 &&
> +		       res.a1 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1 &&
> +		       res.a2 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2 &&
> +		       res.a3 == ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3,
> +		       "Unexpected KVM-specific UID %lx %lx %lx %lx\n", res.a0, res.a1, res.a2, res.a3);
> +	GUEST_DONE();
> +}
> +
> +int main (int argc, char *argv[])
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	bool guest_done = false;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	while (!guest_done) {
> +		vcpu_run(vcpu);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			guest_done = true;
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_PRINTF:
> +			printf("%s", uc.buffer);
> +			break;
> +		default:
> +			TEST_FAIL("Unexpected guest exit");
> +		}
> +	}

This is becoming a very common and useful pattern. I wonder if it's time
for a ucall helper

static void ucall_vcpu_run(struct kvm_vcpu *vcpu,
                           void (*sync_func)(struct kvm_vcpu *, void *),
                           void *sync_data)
{
        bool guest_done = false;
        struct ucall uc;

        while (!guest_done) {
                vcpu_run(vcpu);

                switch (get_ucall(vcpu, &uc)) {
                case UCALL_SYNC:
                        if (sync_func)
                                sync_func(vcpu, sync_data);
                        break;
                case UCALL_DONE:
                        guest_done = true;
                        break;
                case UCALL_ABORT:
                        REPORT_GUEST_ASSERT(uc);
                        break;
                case UCALL_PRINTF:
                        printf("%s", uc.buffer);
                        break;
                default:
                        TEST_FAIL("Unexpected guest exit");
                }
        }
}

Thanks,
drew

> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> -- 
> 2.39.2
> 

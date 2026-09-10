Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F2E3B8406
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789066663; cv=pass; b=SCItuO1WAL5rT3WdMCxvMkPx7gzl51sXnEvhEiZLN0BlxNlCMKZDwrch7Of33NDbOdJqZ7MUMPYASqKzKm81LW514/jHTlVAMT2jxJJIpuiz/ZJZlNKpLy3ZpNF3H20oBxLvE85mc3czwC3A+cm5C9H4ho6p2If/lIaYroy1GsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789066663; c=relaxed/simple;
	bh=LvLi2WG97zBBaTutxiZFhYxTjRdgTSJJxA2epdOyf9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VoQMnQUQ61hpC6rN7ra1pswym+3w9URiNX/AZWlAGbH6uiOHBjyA/kdVvclRxw8HR8oBkpr0wN8nizq9z6k60RhELYnaXzOVmUUrYpGaGkdBFknk6DVkEJEak5y4a3LXIO+Ffuct4SaXZs6rsIiMbjEaYBNMPG5Fh3XTthsGpgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YRBy1tiy; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YRBy1tiy"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so10175e87.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:57:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789066660; cv=none;
        d=google.com; s=arc-20260327;
        b=YVxKVXALiyqfEDRmKjxxUwbZnXyZvUyIBlj3n0amcos4jkEMV51PV7EiUmI/krq60t
         ymgK1hyY03DZJWSNurbf/yql/Yhdw5owf+PZBjK2zYiR54vFdMKIfUwlA8FYDqX9SDIy
         WBUa5nLpASR4HMBydzj6PbhGqTmbLlyku4KP6uvBX/TIr+RvqYRUqXAf6iXSvP4ARnq/
         DKlhWYlHgNyBLbXze60qJzxooLFC0/sZFZ6gXmNLLTpQCyICUVNmnm/mnZiE8rmRRgsm
         nO0lEk+AHwBk6QQASaM4HnjncbmMtZpYIYMi5tWGguQaAqRBql+p4WeiThiQ5G7+NRDW
         q7Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZrdVF7ALBocEe70y9+Oret+TDRXY2tEOhMpJsYsf+II=;
        fh=7Dfp7GbOM5FyQhaLPVlvcIITJqt4srXHKaNqur8VdOY=;
        b=anjHL+EaVXhkKHcGZf9aZTxULENOJbtw9Tk2PjJbjzoWxPLEb6iGPpTNw86haIAJjU
         ZVQjOBV6tefn4kME4uR69SdDGw2eL7TOmODI/Y/Ax6aNlAZVvpuMH1O4aDGT5Hu90rx0
         F9pClWhoQcFU+m6GKT/Wo81G6Owxpe1v0W6CdbTFnsYVdpM5xDCopsi53jKBPPVqfhGY
         v8HIu9vbid7bhi8huTAG8R9aAAoWlpw53q6hR5Iv5y2ju4xGkLgKL+D+eF/FhHSJ+b3W
         kCrYvnXy9GlNZEey/tCXnNNKfxB6olmrAqTzbHW+aM8XSu/0Q+QvYAVuhCU8gJvws3ij
         SbSw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789066660; x=1789671460; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZrdVF7ALBocEe70y9+Oret+TDRXY2tEOhMpJsYsf+II=;
        b=YRBy1tiyOOTTaSuukWUUMQaOxefJ/my9OpvTg1boACYv2j9+VxCb77FPKOdKRf+s6Z
         r+DyWEVoTnO05GyeZ8/Dn2yRt8BlglkOLBmTTkj03Ii25SEND3t1OnlIdB/9YcF7Bxtd
         JrAdMy+y5ui88TLB6E6KdIt9Qcm/MlcbiUtXj1Sk88dygEivNeNQRl2315R7vN5zD1Il
         j5F8/iHZqx1vCqxbulh8f70XAJ9C7uryXnCCGi1HA8qwBe5wUa2Xnp4+/vEYb0jkc9mb
         qXsQUm3bKfP+ZudS2Jxe7F/2gQvQYgRBQpywmkQ1cFJ4lFa+WrmG5AkpwHfVu/m8SQ8Y
         tD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789066660; x=1789671460;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZrdVF7ALBocEe70y9+Oret+TDRXY2tEOhMpJsYsf+II=;
        b=fdzqvF6fDmdxsyZO0njs6u95ETsyy9Pwy560lLIQvnThbbvsn0bll07+i+wKJuhY5u
         kK+nVbxcvbWthap8Oo2Zt7JTohIYUtSITuI22jYRAsFIiegJ8d807P5k4Ljj9Pi7OiWU
         BWEO2HcAnkpCFVgC0rYjskwgHj4ESx8ReufDKM9CBT0tgI9o5JqvgTgIXecgoTN62zcb
         U+ODh1P0eymI863A8vRQsAEDYRDGtvPS1uOnp+d8WZNDa09rOqbUN4THDiT7tf3V6Jht
         Ia6UOv+vs7JhWKkdxa/4JOSdg0iNpfOY2nIIHbrFBPdT8jzkqfl1On1H06odF0cFXXhU
         ezjg==
X-Forwarded-Encrypted: i=1; AKwUvBwUPTgFTC4NX+Kjkwijqc3GUkhCQprKMuZPyxk2aS13Sz/xAa8pzsWol5PIN7rOKgxz5pmAP14=@lists.linux.dev
X-Gm-Message-State: AFuF++lbh1UaYxNymq9IGw/JE+O449OFZqo+I2BrJsBqTpgZyvCK4h8D
	94UG7X3jxJuGrASPIogyONvb2zHOCUAEEp62s6Bi8PsuX9WdSmsnZ+gb+JAuFURLQDAE9V9O55m
	rlRGbR8qjt23+g19UcUcvF09PiyPvka8boSB3mg3F
X-Gm-Gg: AYBFou3z4MkIGQoGOOgRRsy7nqLmHaq3d+jNKkPtyuBCH1AdNdQdIQrSoXoMqtlKHjO
	AvbL8wyPODPTXpIELMNFlv+ZDz9TvfM1089SBXAbtXqxrgQbAsOax4bzxU0RjxdXcH+oqSFpLiY
	Z7sthWMw8PAiQN8lUYUQYPw/IJO/6IsJXaS6GZb7dKoi6C/HDB72OGZYkHcoEmgythRu0Rq/ad6
	kcU35zMvGVKCwZyxAEEkILwbSM7a8I0MuME7B1fWrboQ8V8REuRiIe8Y12O/UGgWeZMzTmnEopM
	UWisg7QXSZkOJ2HFyJXoS5DxRXX0enTDpUaMYluRHasVFFEMwQjrjpoyulxUejVg9FLYyVliR8S
	Y/Cjw433fzdmSY/044SGK456j
X-Received: by 2002:a05:6512:108c:b0:5b2:a967:c0c9 with SMTP id
 2adb3069b0e04-5b8a07ad04amr18706e87.7.1789066659207; Thu, 10 Sep 2026
 11:57:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org> <20260825-kvm-arm-prefault-v1-8-befe8947702e@kernel.org>
In-Reply-To: <20260825-kvm-arm-prefault-v1-8-befe8947702e@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 10 Sep 2026 19:57:03 +0100
X-Gm-Features: AcwNN1WRbRt_RViN6lNXEa633ZkRLMSCIUfMJ0FeZLRCcdVLjr-AEUXzwXInRdA
Message-ID: <CA+EHjTy8m=b8D6sLOTv3AW05vXqFPRrTYvG7-t3D64Vt1+jAWQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] KVM: selftests: Add nested pre-fault test for arm64
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, 25 Aug 2026 at 17:02, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
..
> +int main(void)
> +{
> +       struct nested_s2_state s2;
> +       struct kvm_vcpu_init init;
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_vm *vm;
> +       struct ucall uc;
> +       u64 npages;
> +
> +       TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));

Would test_supports_el2() work better here? It honours the NV=0
opt-out, and since HAS_EL2 is set unconditionally below, NV=0 doesn't
disable this test as things stand.

Cheers,
/fuad

> +       TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
> +
> +       vm = vm_create(1);
> +
> +       kvm_get_default_vcpu_target(vm, &init);
> +       init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
> +       vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> +       kvm_arch_vm_finalize_vcpus(vm);
> +
> +       npages = TEST_MEM_SIZE / vm->page_size;
> +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, TEST_MEM_GPA,
> +                                   TEST_MEM_SLOT, npages, 0);
> +       virt_map(vm, TEST_MEM_GPA, TEST_MEM_GPA, npages);
> +
> +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +                                   NESTED_S2_ROOT_GPA, NESTED_S2_ROOT_SLOT,
> +                                   vm_adjust_num_guest_pages(vm->mode, 1), 0);
> +
> +       /* Run the guest until it has ERET'd from vEL2 to vEL1. */
> +       vcpu_run(vcpu);
> +       switch (get_ucall(vcpu, &uc)) {
> +       case UCALL_SYNC:
> +               TEST_ASSERT_EQ(uc.args[1], 1);
> +               break;
> +       case UCALL_ABORT:
> +               REPORT_GUEST_ASSERT(uc);
> +               break;
> +       default:
> +               TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> +       }
> +
> +       /*
> +        * The vCPU's last-run context is vEL1, backed by a shadow stage-2
> +        * MMU. Enable nested stage-2 with an empty root so that the ioctl
> +        * fails if it tries to interpret the userspace GPA as an L2 IPA.
> +        *
> +        * Prefault in two halves so that the second ioctl exercises a
> +        * repeated shadow-MMU attach and canonical stage-2 swap.
> +        *
> +        * (Note that an implementation that wrongly populates shadow
> +        * stage-2 page tables would not be caught as userland can't
> +        * inspect these.)
> +        */
> +       s2 = enable_empty_nested_s2(vcpu);
> +       pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE / 2);
> +       pre_fault(vcpu, TEST_MEM_GPA + TEST_MEM_SIZE / 2, TEST_MEM_SIZE / 2);
> +       restore_nested_s2(vcpu, &s2);
> +
> +       /* Resume at vEL1 and touch the prefaulted range. */
> +       vcpu_run(vcpu);
> +       switch (get_ucall(vcpu, &uc)) {
> +       case UCALL_DONE:
> +               break;
> +       case UCALL_ABORT:
> +               REPORT_GUEST_ASSERT(uc);
> +               break;
> +       default:
> +               TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> +       }
> +
> +       kvm_vm_free(vm);
> +       return 0;
> +}
>
> --
> 2.55.0
>

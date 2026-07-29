Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69251411A00
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338613; cv=pass; b=e7mpkXMoGSrEDdAxJ2OEy6Be6x4ztnOglI0d4xfmnA7+bucL7Zei0cxWwlsoJwXcjvZ+sFlQkhFkUcMVvHglcVoOKglks2po3ms0Rq9j0i0qfKMPhZyfBzwXLWZYbKvIBUtPFuKqNrdvZs7yhE/yHT9WWHcXewxPhWkoHHS8+9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338613; c=relaxed/simple;
	bh=LVBzsbGMtEvkKYlB4ymkqikHz0oYkp14Iw5Po3+7C0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i5QVnUwkzzwYK6kIC1x5yXpMvFQc1e5k9G+0WIazrHu6mx+8X7Y7qAz0iT4YUmnQdW0Mu01H2IKFfSf9T9nYAwUIe/gQHwKNyRY79f953N+46Oeb3ajvmnnikBm1W15ed6vugC8VTNjgrImavRQEb0i7kjXrlx+L9gdsfu9yU/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZyQH4Tyy; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZyQH4Tyy"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c10e86e52so281591cf.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 08:23:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785338610; cv=none;
        d=google.com; s=arc-20260327;
        b=W2+bpMBNBc15IRHY8WWSJkiVB7GRxTK/dkXvfQKTe+Z4toSCmb7EuGiHDhIJt1kN4f
         kxt/Ht1St3jPBkOGo3d15Eryy+hFZt8iEZC5vANEC3xYHT5rgkn3vMGfGd3V+XrVdY/h
         x3ZuprMA4lTfg9ZUxjTk1jUNec6vN6FOMCGjG5/rIIEioDbCi6VP3T3zcGPLQSynTKRD
         OUimdHwQjE/NmKHzYAxZYs+PzLxG6G2uk9iul9X2nveWBjioFF8FMigqKFQimmaYvpb3
         snZ4AV6BEcquB2SaLE/bPAh9C/BQIjQHNEnkim4nnT8W5T9HMbwuj1mbO2CxP9EVDbSI
         F8KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EYpYlO78zITH6UjIoefobo5Po8cUwvLKaBgMucaKFtQ=;
        fh=RNsxJTsYp+75Dc+mGmF89Im26btAb3LXA+bimSiSkyg=;
        b=ht8+zfTd639164RezxJ5aQ0T9n4/pwYlXsVjGfcRp3l58lSp1ybM0f0phGW1WlJfRG
         C/nfymqC+6j8cAG8n+5RfM5+cjfKgucg5NBhE1LjTLbMJFQX3gmq6I4C3QUJeS72MrCV
         6obHZftQ74y9FlMIIIWoQmq8eJxeV7Yg/6541fYqF2eKQXwgkOOsBbUQR2ghkzNt/2JJ
         090ACwLhrCvlkUWba5GEA/kP46vqNFPgsiqbCEhUb8FLDfpenkcc2DiQ4Zmy0kL/sYGI
         FzuzYr1u1JtpNwiTGSS30epIxEWAI7DNuAoMupPO7tFhn15VqBEs7yBnrccyrPVb7hNP
         T5ow==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785338610; x=1785943410; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYpYlO78zITH6UjIoefobo5Po8cUwvLKaBgMucaKFtQ=;
        b=ZyQH4Tyy83/PxmNTvSQuPxK3PHFodAaIkuXHBhPQHewtu3fqQfk4zHEoq4MFNo+51W
         K+YiJC+ehSetaeCsEAJuB7qH/dEpxQGVDXJP1R0WiNT6Cpy9zDdgL8rx2VPKICaGVUlE
         OWRKvTqilm1a1bae0UFBotQeybCet34+2xcZsjQXdQ5ylfc0eKLkGfNv2xW/L4pSQMdB
         KNF479OQoQqNGEspLHESZilDLFussoUkFGgg/OGR+5dvx4AGuts/myqTIzTZDgNwHiea
         DN2kRD9MFzE5zd8uOSpvsWkgwxXA6aYhqGaewvyca/F9MkeBMheoDrKfk5AUxZ9sDpqn
         58jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338610; x=1785943410;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EYpYlO78zITH6UjIoefobo5Po8cUwvLKaBgMucaKFtQ=;
        b=GmdQFLlp2u0g7QEc+yPg76JKI3z6YquzXBj3H4YoyqWDCT4XCNkCUVhHP+hMqWGgIr
         gNyWe6PMLgXzOmemcrWtXH4PW3d3ser7+0BMBLAAJq2ggfkNmpbeMZFyoeWMTP/duKXl
         dr0CrA2CDuAYH8aWMFVFP2OoC3J8GDt4iwOXN2sjqCuZ9RVKQ6dQCvaa4RQ9cQmT2AFp
         iuzRCeqt++9Wi54YhESLOsVkXYKiSbxtdO37nqqSNFiuYPv3STd1LIZ79cvDPYMV7x07
         QnZ2yHPU/obX86oAT0oPonbpGZKxlu2ANppTaxrsvKGf6Rl7KNgWCCt0scQLJjXqci1L
         mH9A==
X-Forwarded-Encrypted: i=1; AHgh+RoKd8F4Lwz5EAlUV37uHQlHhHWO6YdzcAXNTQXCZvdXlnrVG9NHAFUF3rCQLsbK1mRcMza7waM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwndAWjwZ604goRcTubo1ghIQDQ8RPiKSkjGO4Eo4VnzKzZtUak
	Vklfq2G8uPoFuGFeVhQRJz45gAEwz+T3Fe1KJ2X99BYMTlmVP+0znBXFCMuI1Cq/8AWfo2dGPrJ
	8+ubb6H/wnbKS+Yku/r0RsdUnOCs+Wjnex9f7j0bG
X-Gm-Gg: AR+sD13/Ej8dcti58Flj3zDYpA2vVDm2vlmQ0tH8525nqh+6ShuEkMexLwrQ/muf5kh
	X15msLNlFtmsEuI7WTMBg9gaYdTN4sjISWRyXt/DRH1unZ2wVw/Z3WigazFP66zOIJNTtxOVofr
	Nn0gYdFc2bHFkCaO/FEU4lOtKUSr+rBsdxdShtxS+YnFuYN77e/k4OTqpeiVWzdS+4gRSZqwcZW
	xjh9QsmTkXnQN1C3aHFJTXVgInjzztenY5rCw34T0I9wgptzaZ7erS8TAzpRkJjWGgFqhPnLA9L
	MpXGvm831SR8Reh7wVFBl4fvvr9ln9OWCFrQs7M/lXIzD0bwKbEnOUqojldriLYBzNc/juk/diZ
	MBPqyoJaYEA==
X-Received: by 2002:ac8:7c56:0:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-52b35089837mr565631cf.8.1785338608520; Wed, 29 Jul 2026
 08:23:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 29 Jul 2026 16:22:51 +0100
X-Gm-Features: AUfX_mwUs9MTXlZgLAxa7rxOqn4AEWfpGlzGWJmBR-6Vw5CXw5g4z3qo-EMbdA0
Message-ID: <CA+EHjTzwDrP=3a7f38e2H_H1YPV0igRryhfuNCigZQUFy02tng@mail.gmail.com>
Subject: Re: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS
 after first run
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Steffen Eiden <seiden@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Jul 2026 at 06:44, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> Add a regression test that runs one vCPU and then tries to change the
> VM-scoped PMU counter count through an idle sibling. Verify that
> SET_NR_COUNTERS fails with EBUSY once any vCPU has run.
>
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  .../selftests/kvm/arm64/vpmu_counter_access.c      | 38 ++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> index 22223395969e..3b5bb421f401 100644
> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> @@ -461,6 +461,11 @@ static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
>         }
>  }
>
> +static void guest_code_done(void)
> +{
> +       GUEST_DONE();
> +}
> +
>  static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
>  {
>         struct kvm_vcpu *vcpu;
> @@ -622,6 +627,37 @@ static bool kvm_supports_nr_counters_attr(void)
>         return supported;
>  }
>
> +static void test_set_nr_counters_after_vcpu_run(void)
> +{
> +       struct kvm_vcpu *running_vcpu, *stopped_vcpu;
> +       unsigned int nr_counters = 0;
> +       struct kvm_vcpu_init init;
> +       struct kvm_vm *vm;
> +       int ret;
> +       u64 irq = 23;
> +
> +       vm = vm_create(2);
> +       vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +       init.features[0] |= BIT(KVM_ARM_VCPU_PMU_V3);
> +       running_vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code_done);
> +       stopped_vcpu = aarch64_vcpu_add(vm, 1, &init, guest_code_done);
> +       kvm_arch_vm_finalize_vcpus(vm);
> +
> +       vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> +       vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                            KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> +       vcpu_run(running_vcpu);
> +
> +       ret = __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +                                    KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS,
> +                                    &nr_counters);
> +       TEST_ASSERT(ret == -1 && errno == EBUSY,
> +                   KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> +
> +       kvm_vm_free(vm);
> +}
> +
>  int main(void)
>  {
>         u64 i, pmcr_n;
> @@ -630,6 +666,8 @@ int main(void)
>         TEST_REQUIRE(kvm_supports_vgic_v3());
>         TEST_REQUIRE(kvm_supports_nr_counters_attr());
>
> +       test_set_nr_counters_after_vcpu_run();
> +
>         pmcr_n = get_pmcr_n_limit();
>         for (i = 0; i <= pmcr_n; i++) {
>                 run_access_test(i);
>
> --
> 2.55.0
>
>

Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8564AC48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 08:03:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 032BF613FA
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 08:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 032BF613FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748694B0EE;
	Tue, 15 Jun 2021 04:03:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wBQOozud9v+X; Tue, 15 Jun 2021 04:03:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 733034B0E4;
	Tue, 15 Jun 2021 04:03:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F236C4B0CF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 04:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i6OcEifMTiEM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 04:03:53 -0400 (EDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB90649E8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 04:03:52 -0400 (EDT)
Received: by mail-ot1-f47.google.com with SMTP id
 i12-20020a05683033ecb02903346fa0f74dso13451103otu.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 01:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2CSh1z7Vp1/cJggYoB1jYFqsZlnKuhPcaTsNgRYwVSI=;
 b=O8yz83yvBRCtMVSzbGCfMg/eHcmAvfvQZTkOIrDmMi4Ya9lSWjT7L4v+4BdKPCHAr7
 o8i/5oXrv/AX3rVcPJxU+O2mwmLoFJX9GDiqaz5HSgNfEsgXYCPNJcP9FgE7IRuDoNkx
 tFHDu7d25Ci7vkTPCNOjJ0ZeoYPOGokqwLAGhgNmbyNuAeTPp5zd/L63WYBxn4HYzh91
 dRMVX09ftVaQWQV+pkiXcPlwECefKY/kQlEEaHx+kpinhn6YKL1DlJZq56FcetiW7RNx
 Kb+r7EfzgK//Y13xIojAuhb9Q27hA0AvG7oieQon3sgYE3dxk47SHgpgdFK6ACeBafwq
 FXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2CSh1z7Vp1/cJggYoB1jYFqsZlnKuhPcaTsNgRYwVSI=;
 b=rvcxL7j58v7mP3L/x8LiIg3greqP6vUgXv3SQAF/YLppJ+5jeiU5N5bGLqVdp72BpA
 hQPscZQaEfWKiTS6zYXF8wTWBQnLVxVs22KGnvMWcCZz89OQ1HxQNF43i4yWm6rIu2Yp
 RWOPwa1Qdmbr0mxvPk0oklMm3oT+ksM6mp5A9QD0Gp5lm4XRe+2wBIZDabvmuxCjhpkQ
 q0AbDpHZ3xMPZJurPMkfpBd5zsSjA9A/DJV3lhPvtQ2CwlA1nthj4HIRTA4eHajrMhqQ
 7BAlcW83gXJhgL2JBxUMY4/xSWnQfSdQm7APAdFaVyxv/hWD8KLYoSClO7ZYN40FdbhV
 ra2Q==
X-Gm-Message-State: AOAM53080acjo6djDDf68OZ0d87AAyaBoWpUes+sQ3tNYAzogLMl16wW
 mhe7zKoPFd2ufXjNMxx5jeeKtD9Rt0+Gn6W2Jie0Ug==
X-Google-Smtp-Source: ABdhPJw2enLCtbwE/790AuD9R9YvbkgrP2ijrQxAzA0UdoAox+QIbPoUXnczIrY5AxRCozcc/VKv6rYEd/Kk/Su7FrA=
X-Received: by 2002:a05:6830:1002:: with SMTP id
 a2mr16213078otp.144.1623744231983; 
 Tue, 15 Jun 2021 01:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-5-jingzhangos@google.com>
In-Reply-To: <20210614212155.1670777-5-jingzhangos@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 15 Jun 2021 09:03:15 +0100
Message-ID: <CA+EHjTybjrYL5KUJebmjvj_R5yULDxXsiPzn6f5f-y5HzQqM6A@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] KVM: selftests: Add selftest for KVM statistics
 data binary interface
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Jing,

> +int main(int argc, char *argv[])
> +{
> +       int max_vm = DEFAULT_NUM_VM, max_vcpu = DEFAULT_NUM_VCPU, ret, i, j;
> +       struct kvm_vm **vms;
> +
> +       /* Get the number of VMs and VCPUs that would be created for testing. */
> +       if (argc > 1) {
> +               max_vm = strtol(argv[1], NULL, 0);
> +               if (max_vm <= 0)
> +                       max_vm = DEFAULT_NUM_VM;
> +       }
> +       if (argc > 2) {
> +               max_vcpu = strtol(argv[2], NULL, 0);
> +               if (max_vcpu <= 0)
> +                       max_vcpu = DEFAULT_NUM_VCPU;
> +       }
> +
> +       /* Check the extension for binary stats */
> +       ret = kvm_check_cap(KVM_CAP_BINARY_STATS_FD);
> +       TEST_ASSERT(ret >= 0,
> +                       "Binary form statistics interface is not supported");

kvm_check_cap returns the value of KVM_CHECK_EXTENSION, which is 0 if
unsupported (-ERROR on an error). The assertion should be for ret > 0.

Made that change locally, and tested it with various configurations
(vhe, nvhe), as well as kernel versions (with and without
KVM_CAP_BINARY_STATS_FD), and it passes (or fails as expected).
Without that fix and with a kernel that doesn't support
KVM_CAP_BINARY_STATS_FD, it passes that assertion, but fails later at
vcpu_stats_test().

With that fixed:
Tested-by: Fuad Tabba <tabba@google.com> #arm64

Cheers,
/fuad


> +
> +       /* Create VMs and VCPUs */
> +       vms = malloc(sizeof(vms[0]) * max_vm);
> +       TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
> +       for (i = 0; i < max_vm; ++i) {
> +               vms[i] = vm_create(VM_MODE_DEFAULT,
> +                               DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +               for (j = 0; j < max_vcpu; ++j)
> +                       vm_vcpu_add(vms[i], j);
> +       }
> +
> +       /* Check stats read for every VM and VCPU */
> +       for (i = 0; i < max_vm; ++i) {
> +               vm_stats_test(vms[i]);
> +               for (j = 0; j < max_vcpu; ++j)
> +                       vcpu_stats_test(vms[i], j);
> +       }
> +
> +       for (i = 0; i < max_vm; ++i)
> +               kvm_vm_free(vms[i]);
> +       free(vms);
> +       return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5c70596dd1b9..83c02cb0ae1e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2286,3 +2286,15 @@ unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
>         n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
>         return vm_adjust_num_guest_pages(mode, n);
>  }
> +
> +int vm_get_stats_fd(struct kvm_vm *vm)
> +{
> +       return ioctl(vm->fd, KVM_GET_STATS_FD, NULL);
> +}
> +
> +int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +       struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +       return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
> +}
> --
> 2.32.0.272.g935e593368-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

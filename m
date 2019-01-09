From: kbuild test robot <lkp@intel.com>
Subject: [kvmarm:kvm-arm64/nv-wip-v5.0-rc1 45/75]
 arch/arm/kvm/../../../virt/kvm/arm/arm.c:1003:3: error: implicit declaration
 of function 'kvm_nested_s2_clear'; did you mean '__nodes_clear'?
Date: Wed, 9 Jan 2019 17:22:20 +0800
Message-ID: <201901091736.rAIoRLZM%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9C474A3FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 04:22:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eECIgJB+qUfu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jan 2019 04:22:51 -0500 (EST)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08E024A3BC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 04:22:50 -0500 (EST)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jintack Lim <jintack.lim@linaro.org>, kbuild-all@01.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm64/nv-wip-v5.0-rc1
head:   688c386ca096f2c1f2eee386697586c88df5d5bc
commit: 3da39279c7b03e5f797de7c283a0de99f69e6a17 [45/75] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
config: arm-axm55xx_defconfig (attached as .config)
compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 3da39279c7b03e5f797de7c283a0de99f69e6a17
        # save the attached .config to linux build tree
        GCC_VERSION=7.2.0 make.cross ARCH=arm 

All errors (new ones prefixed by >>):

   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_init_vm':
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:133:39: error: 'struct kvm_arch' has no member named 'mmu'
     ret = kvm_alloc_stage2_pgd(&kvm->arch.mmu);
                                          ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:138:11: error: 'struct kvm_arch' has no member named 'mmu'
     kvm->arch.mmu.vmid.vmid_gen = 0;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:139:11: error: 'struct kvm_arch' has no member named 'mmu'
     kvm->arch.mmu.kvm = kvm;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:140:11: error: 'struct kvm_arch' has no member named 'mmu'
     kvm->arch.mmu.vttbr = -1;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:141:11: error: 'struct kvm_arch' has no member named 'mmu'
     kvm->arch.mmu.nested_stage2_enabled = false;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:143:11: error: 'struct kvm_arch' has no member named 'nested_mmus'
     kvm->arch.nested_mmus = NULL;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:144:11: error: 'struct kvm_arch' has no member named 'nested_mmus_size'
     kvm->arch.nested_mmus_size = 0;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:158:32: error: 'struct kvm_arch' has no member named 'mmu'
     kvm_free_stage2_pgd(&kvm->arch.mmu);
                                   ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_vcpu_init':
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:363:12: error: 'struct kvm_vcpu_arch' has no member named 'hw_mmu'
     vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
               ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:363:38: error: 'struct kvm_arch' has no member named 'mmu'
     vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
                                         ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_vcpu_load':
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:372:2: error: implicit declaration of function 'kvm_vcpu_load_hw_mmu'; did you mean 'kvm_vcpu_load_sysregs'? [-Werror=implicit-function-declaration]
     kvm_vcpu_load_hw_mmu(vcpu);
     ^~~~~~~~~~~~~~~~~~~~
     kvm_vcpu_load_sysregs
   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_vcpu_put':
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:406:2: error: implicit declaration of function 'kvm_vcpu_put_hw_mmu'; did you mean 'kvm_vcpu_dabt_is_cm'? [-Werror=implicit-function-declaration]
     kvm_vcpu_put_hw_mmu(vcpu);
     ^~~~~~~~~~~~~~~~~~~
     kvm_vcpu_dabt_is_cm
   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:689:26: error: 'struct kvm_vcpu_arch' has no member named 'hw_mmu'
      update_vmid(&vcpu->arch.hw_mmu->vmid);
                             ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:738:48: error: 'struct kvm_vcpu_arch' has no member named 'hw_mmu'
      if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
                                                   ^
   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_set_target':
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:973:15: error: 'KVM_ARM_VCPU_NESTED_VIRT' undeclared (first use in this function); did you mean 'KVM_ARM_VCPU_TIMER_CTRL'?
     if (test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features)) {
                  ^~~~~~~~~~~~~~~~~~~~~~~~
                  KVM_ARM_VCPU_TIMER_CTRL
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:973:15: note: each undeclared identifier is reported only once for each function it appears in
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:976:8: error: implicit declaration of function 'cpus_have_const_cap'; did you mean 'cpu_have_feature'? [-Werror=implicit-function-declaration]
      if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
           ^~~~~~~~~~~~~~~~~~~
           cpu_have_feature
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:976:28: error: 'ARM64_HAS_NESTED_VIRT' undeclared (first use in this function); did you mean 'KVM_ARM_VCPU_NESTED_VIRT'?
      if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
                               ^~~~~~~~~~~~~~~~~~~~~
                               KVM_ARM_VCPU_NESTED_VIRT
   arch/arm/kvm/../../../virt/kvm/arm/arm.c:979:9: error: implicit declaration of function 'kvm_vcpu_init_nested'; did you mean 'kvm_vcpu_initialized'? [-Werror=implicit-function-declaration]
      ret = kvm_vcpu_init_nested(vcpu);
            ^~~~~~~~~~~~~~~~~~~~
            kvm_vcpu_initialized
   arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_arch_vcpu_ioctl_vcpu_init':
>> arch/arm/kvm/../../../virt/kvm/arm/arm.c:1003:3: error: implicit declaration of function 'kvm_nested_s2_clear'; did you mean '__nodes_clear'? [-Werror=implicit-function-declaration]
      kvm_nested_s2_clear(vcpu->kvm);
      ^~~~~~~~~~~~~~~~~~~
      __nodes_clear
   cc1: some warnings being treated as errors
--
                             ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:182:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr_t addr)
                ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:313:38: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
                                         ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'unmap_stage2_puds':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:316:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:328:28: error: passing argument 1 of 'kvm_tlb_flush_vmid_ipa' from incompatible pointer type [-Werror=incompatible-pointer-types]
        kvm_tlb_flush_vmid_ipa(mmu, addr);
                               ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:69:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
                ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:332:23: error: passing argument 1 of 'unmap_stage2_pmds' from incompatible pointer type [-Werror=incompatible-pointer-types]
        unmap_stage2_pmds(mmu, pud, addr, next);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:283:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void unmap_stage2_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
                ^~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:338:26: error: passing argument 1 of 'clear_stage2_pgd_entry' from incompatible pointer type [-Werror=incompatible-pointer-types]
      clear_stage2_pgd_entry(mmu, pgd, start_addr);
                             ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:171:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu, pgd_t *pgd, phys_addr_t addr)
                ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:316:14: warning: unused variable 'kvm' [-Wunused-variable]
     struct kvm *kvm = mmu->kvm;
                 ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:352:36: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
                                       ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_unmap_stage2_range':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:354:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:373:22: error: passing argument 1 of 'unmap_stage2_puds' from incompatible pointer type [-Werror=incompatible-pointer-types]
       unmap_stage2_puds(mmu, pgd, addr, next);
                         ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:313:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
                ^~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:383:38: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static void stage2_flush_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
                                         ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:395:38: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static void stage2_flush_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
                                         ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_flush_pmds':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:398:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:409:23: error: passing argument 1 of 'stage2_flush_ptes' from incompatible pointer type [-Werror=incompatible-pointer-types]
        stage2_flush_ptes(mmu, pmd, addr, next);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:383:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void stage2_flush_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
                ^~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:414:38: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static void stage2_flush_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
                                         ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_flush_puds':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:417:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:428:23: error: passing argument 1 of 'stage2_flush_pmds' from incompatible pointer type [-Werror=incompatible-pointer-types]
        stage2_flush_pmds(mmu, pud, addr, next);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:395:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void stage2_flush_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
                ^~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:417:14: warning: unused variable 'kvm' [-Wunused-variable]
     struct kvm *kvm = mmu->kvm;
                 ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:433:36: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
                                       ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_stage2_flush_range':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:436:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:444:22: error: passing argument 1 of 'stage2_flush_puds' from incompatible pointer type [-Werror=incompatible-pointer-types]
       stage2_flush_puds(mmu, pgd, addr, next);
                         ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:414:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void stage2_flush_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
                ^~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:448:41: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
                                            ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_flush_memslot':
>> arch/arm/kvm/../../../virt/kvm/arm/mmu.c:454:25: error: passing argument 1 of 'kvm_stage2_flush_range' from incompatible pointer type [-Werror=incompatible-pointer-types]
     kvm_stage2_flush_range(mmu, addr, end);
                            ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:433:6: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
         ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_flush_vm':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:475:34: error: 'struct kvm_arch' has no member named 'mmu'
      stage2_flush_memslot(&kvm->arch.mmu, memslot);
                                     ^
>> arch/arm/kvm/../../../virt/kvm/arm/mmu.c:477:2: error: implicit declaration of function 'kvm_nested_s2_flush'; did you mean 'kvm_set_way_flush'? [-Werror=implicit-function-declaration]
     kvm_nested_s2_flush(kvm);
     ^~~~~~~~~~~~~~~~~~~
     kvm_set_way_flush
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:928:33: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu)
                                    ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:928:5: error: conflicting types for 'kvm_alloc_stage2_pgd'
    int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu)
        ^~~~~~~~~~~~~~~~~~~~
   In file included from arch/arm/kvm/../../../virt/kvm/arm/mmu.c:28:0:
   arch/arm/include/asm/kvm_mmu.h:67:5: note: previous declaration of 'kvm_alloc_stage2_pgd' was here
    int kvm_alloc_stage2_pgd(struct kvm *kvm);
        ^~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_alloc_stage2_pgd':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:932:9: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     if (mmu->pgd != NULL) {
            ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_unmap_memslot':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:982:37: error: 'struct kvm_arch' has no member named 'mmu'
       kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
                                        ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1014:33: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
                                    ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1014:6: error: conflicting types for 'kvm_free_stage2_pgd'
    void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
         ^~~~~~~~~~~~~~~~~~~
   In file included from arch/arm/kvm/../../../virt/kvm/arm/mmu.c:28:0:
   arch/arm/include/asm/kvm_mmu.h:68:6: note: previous declaration of 'kvm_free_stage2_pgd' was here
    void kvm_free_stage2_pgd(struct kvm *kvm);
         ^~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_free_stage2_pgd':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1016:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1021:26: error: passing argument 1 of 'kvm_unmap_stage2_range' from incompatible pointer type [-Werror=incompatible-pointer-types]
      kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
                             ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:352:6: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
         ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1022:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      pgd = READ_ONCE(mmu->pgd);
          ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1032:37: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
                                        ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_get_pud':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1035:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1035:14: warning: unused variable 'kvm' [-Wunused-variable]
     struct kvm *kvm = mmu->kvm;
                 ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1051:37: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static pmd_t *stage2_get_pmd(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
                                        ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_get_pmd':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1054:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1058:23: error: passing argument 1 of 'stage2_get_pud' from incompatible pointer type [-Werror=incompatible-pointer-types]
     pud = stage2_get_pud(mmu, cache, addr);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1032:15: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
                  ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1054:14: warning: unused variable 'kvm' [-Wunused-variable]
     struct kvm *kvm = mmu->kvm;
                 ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1073:39: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
                                          ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_set_pmd_huge':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1079:23: error: passing argument 1 of 'stage2_get_pmd' from incompatible pointer type [-Werror=incompatible-pointer-types]
     pmd = stage2_get_pmd(mmu, cache, addr);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1051:15: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static pmd_t *stage2_get_pmd(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
                  ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1112:26: error: passing argument 1 of 'kvm_tlb_flush_vmid_ipa' from incompatible pointer type [-Werror=incompatible-pointer-types]
      kvm_tlb_flush_vmid_ipa(mmu, addr);
                             ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:69:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
                ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1121:39: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static int stage2_set_pud_huge(struct kvm_s2_mmu *mmu,
                                          ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_set_pud_huge':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1125:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1128:24: error: passing argument 1 of 'stage2_get_pud' from incompatible pointer type [-Werror=incompatible-pointer-types]
--
                           ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1032:15: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
                  ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1162:14: warning: unused variable 'kvm' [-Wunused-variable]
     struct kvm *kvm = mmu->kvm;
                 ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1197:35: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static bool stage2_is_exec(struct kvm_s2_mmu *mmu, phys_addr_t addr)
                                      ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_is_exec':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1204:32: error: passing argument 1 of 'stage2_get_leaf_entry' from incompatible pointer type [-Werror=incompatible-pointer-types]
     found = stage2_get_leaf_entry(mmu, addr, &pudp, &pmdp, &ptep);
                                   ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1159:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static bool stage2_get_leaf_entry(struct kvm_s2_mmu *mmu, phys_addr_t addr,
                ^~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1216:34: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static int stage2_set_pte(struct kvm_s2_mmu *mmu,
                                     ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_set_pte':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1221:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1231:23: error: passing argument 1 of 'stage2_get_pud' from incompatible pointer type [-Werror=incompatible-pointer-types]
     pud = stage2_get_pud(mmu, cache, addr);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1032:15: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
                  ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1245:23: error: passing argument 1 of 'stage2_dissolve_pud' from incompatible pointer type [-Werror=incompatible-pointer-types]
      stage2_dissolve_pud(mmu, addr, pud);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:127:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void stage2_dissolve_pud(struct kvm_s2_mmu *mmu, phys_addr_t addr, pud_t *pudp)
                ^~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1269:23: error: passing argument 1 of 'stage2_dissolve_pmd' from incompatible pointer type [-Werror=incompatible-pointer-types]
      stage2_dissolve_pmd(mmu, addr, pmd);
                          ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:108:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t *pmd)
                ^~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1293:26: error: passing argument 1 of 'kvm_tlb_flush_vmid_ipa' from incompatible pointer type [-Werror=incompatible-pointer-types]
      kvm_tlb_flush_vmid_ipa(mmu, addr);
                             ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:69:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
                ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1221:14: warning: unused variable 'kvm' [-Wunused-variable]
     struct kvm *kvm = mmu->kvm;
                 ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_phys_addr_ioremap':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1359:34: error: 'struct kvm_arch' has no member named 'mmu'
      ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
                                     ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1448:35: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static void stage2_wp_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
                                      ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_wp_pmds':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1451:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1478:36: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
                                       ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'stage2_wp_puds':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1481:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1493:20: error: passing argument 1 of 'stage2_wp_pmds' from incompatible pointer type [-Werror=incompatible-pointer-types]
        stage2_wp_pmds(mmu, pud, addr, next);
                       ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1448:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void stage2_wp_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
                ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1481:14: warning: unused variable 'kvm' [-Wunused-variable]
     struct kvm *kvm = mmu->kvm;
                 ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1505:33: warning: 'struct kvm_s2_mmu' declared inside parameter list will not be visible outside of this definition or declaration
    void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
                                    ^~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_stage2_wp_range':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1507:23: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
     struct kvm *kvm = mmu->kvm;
                          ^~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1527:19: error: passing argument 1 of 'stage2_wp_puds' from incompatible pointer type [-Werror=incompatible-pointer-types]
       stage2_wp_puds(mmu, pgd, addr, next);
                      ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1478:14: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
                 ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_mmu_wp_memory_region':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1552:32: error: 'struct kvm_arch' has no member named 'mmu'
     kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
                                   ^
>> arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1553:2: error: implicit declaration of function 'kvm_nested_s2_wp'; did you mean 'kvm_reset_vcpu'? [-Werror=implicit-function-declaration]
     kvm_nested_s2_wp(kvm);
     ^~~~~~~~~~~~~~~~
     kvm_reset_vcpu
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_mmu_write_protect_pt_masked':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1577:32: error: 'struct kvm_arch' has no member named 'mmu'
     kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
                                   ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: At top level:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1676:13: warning: 'struct kvm_s2_trans' declared inside parameter list will not be visible outside of this definition or declaration
         struct kvm_s2_trans *nested,
                ^~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'user_mem_abort':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1693:37: error: 'struct kvm_vcpu_arch' has no member named 'hw_mmu'
     struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
                                        ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1720:6: error: implicit declaration of function 'kvm_is_shadow_s2_fault'; did you mean 'kvm_is_write_fault'? [-Werror=implicit-function-declaration]
     if (kvm_is_shadow_s2_fault(vcpu)) {
         ^~~~~~~~~~~~~~~~~~~~~~
         kvm_is_write_fault
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1721:15: error: dereferencing pointer to incomplete type 'struct kvm_s2_trans'
      ipa = nested->output;
                  ^~
   In file included from include/asm-generic/bug.h:18:0,
                    from arch/arm/include/asm/bug.h:60,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:9,
                    from include/linux/mman.h:5,
                    from arch/arm/kvm/../../../virt/kvm/arm/mmu.c:19:
   include/linux/kernel.h:870:2: error: first argument to '__builtin_choose_expr' not a constant
     __builtin_choose_expr(__safe_cmp(x, y), \
     ^
   include/linux/kernel.h:879:19: note: in expansion of macro '__careful_cmp'
    #define min(x, y) __careful_cmp(x, y, <)
                      ^~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1728:18: note: in expansion of macro 'min'
      max_map_size = min(nested->block_size, max_map_size);
                     ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1821:47: error: passing argument 1 of 'stage2_is_exec' from incompatible pointer type [-Werror=incompatible-pointer-types]
      (fault_status == FSC_PERM && stage2_is_exec(mmu, fault_ipa));
                                                  ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1197:13: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static bool stage2_is_exec(struct kvm_s2_mmu *mmu, phys_addr_t addr)
                ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1833:29: error: passing argument 1 of 'stage2_set_pud_huge' from incompatible pointer type [-Werror=incompatible-pointer-types]
      ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
                                ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1121:12: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static int stage2_set_pud_huge(struct kvm_s2_mmu *mmu,
               ^~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1845:29: error: passing argument 1 of 'stage2_set_pmd_huge' from incompatible pointer type [-Werror=incompatible-pointer-types]
      ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
                                ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1073:12: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
               ^~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1857:24: error: passing argument 1 of 'stage2_set_pte' from incompatible pointer type [-Werror=incompatible-pointer-types]
      ret = stage2_set_pte(mmu, memcache, fault_ipa, &new_pte, flags);
                           ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1216:12: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    static int stage2_set_pte(struct kvm_s2_mmu *mmu,
               ^~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'handle_access_fault':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1886:39: error: 'struct kvm_vcpu_arch' has no member named 'hw_mmu'
     if (!stage2_get_leaf_entry(vcpu->arch.hw_mmu, fault_ipa, &pud, &pmd, &pte))
                                          ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_handle_guest_abort':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1927:22: error: storage size of 'nested_trans' isn't known
     struct kvm_s2_trans nested_trans;
                         ^~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1986:9: error: implicit declaration of function 'kvm_walk_nested_s2'; did you mean 'kvm_inject_nested_irq'? [-Werror=implicit-function-declaration]
      ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
            ^~~~~~~~~~~~~~~~~~
            kvm_inject_nested_irq
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1988:4: error: implicit declaration of function 'kvm_inject_s2_fault'; did you mean 'kvm_inject_pabt'? [-Werror=implicit-function-declaration]
       kvm_inject_s2_fault(vcpu, nested_trans.esr);
       ^~~~~~~~~~~~~~~~~~~
       kvm_inject_pabt
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1993:9: error: implicit declaration of function 'kvm_s2_handle_perm_fault'; did you mean 'handle_mm_fault'? [-Werror=implicit-function-declaration]
      ret = kvm_s2_handle_perm_fault(vcpu, fault_ipa, &nested_trans);
            ^~~~~~~~~~~~~~~~~~~~~~~~
            handle_mm_fault
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1927:22: warning: unused variable 'nested_trans' [-Wunused-variable]
     struct kvm_s2_trans nested_trans;
                         ^~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_unmap_hva_handler':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2093:35: error: 'struct kvm_arch' has no member named 'mmu'
     kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
                                      ^
>> arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2094:2: error: implicit declaration of function 'kvm_nested_s2_clear'; did you mean '__nodes_clear'? [-Werror=implicit-function-declaration]
     kvm_nested_s2_clear(kvm);
     ^~~~~~~~~~~~~~~~~~~
     __nodes_clear
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_unmap_hva_range':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2101:16: error: 'struct kvm_arch' has no member named 'mmu'
     if (!kvm->arch.mmu.pgd)
                   ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_set_spte_handler':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2121:27: error: 'struct kvm_arch' has no member named 'mmu'
     stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
                              ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_set_spte_hva':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2133:16: error: 'struct kvm_arch' has no member named 'mmu'
     if (!kvm->arch.mmu.pgd)
                   ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_age_hva_handler':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2156:39: error: 'struct kvm_arch' has no member named 'mmu'
     if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
                                          ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_test_age_hva_handler':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2181:39: error: 'struct kvm_arch' has no member named 'mmu'
     if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
                                          ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_age_hva':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2199:16: error: 'struct kvm_arch' has no member named 'mmu'
     if (!kvm->arch.mmu.pgd)
                   ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_test_age_hva':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2207:16: error: 'struct kvm_arch' has no member named 'mmu'
     if (!kvm->arch.mmu.pgd)
                   ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_arch_prepare_memory_region':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2420:36: error: 'struct kvm_arch' has no member named 'mmu'
      kvm_unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
                                       ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2422:34: error: 'struct kvm_arch' has no member named 'mmu'
      stage2_flush_memslot(&kvm->arch.mmu, memslot);
                                     ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_arch_flush_shadow_all':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2448:27: error: 'struct kvm_arch' has no member named 'nested_mmus_size'
     for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
                              ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2449:38: error: 'struct kvm_arch' has no member named 'nested_mmus'
      struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
                                         ^
   In file included from arch/arm/include/asm/bug.h:60:0,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:9,
                    from include/linux/mman.h:5,
                    from arch/arm/kvm/../../../virt/kvm/arm/mmu.c:19:
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2451:14: error: dereferencing pointer to incomplete type 'struct kvm_s2_mmu'
      WARN_ON(mmu->usage_count > 0);
                 ^
   include/asm-generic/bug.h:122:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    \
                            ^~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2454:24: error: passing argument 1 of 'kvm_free_stage2_pgd' from incompatible pointer type [-Werror=incompatible-pointer-types]
       kvm_free_stage2_pgd(mmu);
                           ^~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:1014:6: note: expected 'struct kvm_s2_mmu *' but argument is of type 'struct kvm_s2_mmu *'
    void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
         ^~~~~~~~~~~~~~~~~~~
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2456:17: error: 'struct kvm_arch' has no member named 'nested_mmus'
     kfree(kvm->arch.nested_mmus);
                    ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2457:11: error: 'struct kvm_arch' has no member named 'nested_mmus'
     kvm->arch.nested_mmus = NULL;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2458:11: error: 'struct kvm_arch' has no member named 'nested_mmus_size'
     kvm->arch.nested_mmus_size = 0;
              ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2459:32: error: 'struct kvm_arch' has no member named 'mmu'
     kvm_free_stage2_pgd(&kvm->arch.mmu);
                                   ^
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c: In function 'kvm_arch_flush_shadow_memslot':
   arch/arm/kvm/../../../virt/kvm/arm/mmu.c:2469:35: error: 'struct kvm_arch' has no member named 'mmu'
     kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
                                      ^
   cc1: some warnings being treated as errors

vim +1003 arch/arm/kvm/../../../virt/kvm/arm/arm.c

   934	
   935	static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
   936				       const struct kvm_vcpu_init *init)
   937	{
   938		unsigned int i;
   939		int phys_target = kvm_target_cpu();
   940	
   941		if (init->target != phys_target)
   942			return -EINVAL;
   943	
   944		/*
   945		 * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
   946		 * use the same target.
   947		 */
   948		if (vcpu->arch.target != -1 && vcpu->arch.target != init->target)
   949			return -EINVAL;
   950	
   951		/* -ENOENT for unknown features, -EINVAL for invalid combinations. */
   952		for (i = 0; i < sizeof(init->features) * 8; i++) {
   953			bool set = (init->features[i / 32] & (1 << (i % 32)));
   954	
   955			if (set && i >= KVM_VCPU_MAX_FEATURES)
   956				return -ENOENT;
   957	
   958			/*
   959			 * Secondary and subsequent calls to KVM_ARM_VCPU_INIT must
   960			 * use the same feature set.
   961			 */
   962			if (vcpu->arch.target != -1 && i < KVM_VCPU_MAX_FEATURES &&
   963			    test_bit(i, vcpu->arch.features) != set)
   964				return -EINVAL;
   965	
   966			if (set)
   967				set_bit(i, vcpu->arch.features);
   968		}
   969	
   970		vcpu->arch.target = phys_target;
   971	
   972		/* Now we know what it is, we can reset it. */
   973		if (test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features)) {
   974			int ret;
   975	
 > 976			if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
   977				return -EINVAL;
   978	
   979			ret = kvm_vcpu_init_nested(vcpu);
   980			if (ret)
   981				return ret;
   982		}
   983	
   984		return kvm_reset_vcpu(vcpu);
   985	}
   986	
   987	
   988	static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
   989						 struct kvm_vcpu_init *init)
   990	{
   991		int ret;
   992	
   993		ret = kvm_vcpu_set_target(vcpu, init);
   994		if (ret)
   995			return ret;
   996	
   997		/*
   998		 * Ensure a rebooted VM will fault in RAM pages and detect if the
   999		 * guest MMU is turned off and flush the caches as needed.
  1000		 */
  1001		if (vcpu->arch.has_run_once) {
  1002			stage2_unmap_vm(vcpu->kvm);
> 1003			kvm_nested_s2_clear(vcpu->kvm);
  1004		}
  1005	
  1006		vcpu_reset_hcr(vcpu);
  1007	
  1008		/*
  1009		 * Handle the "start in power-off" case.
  1010		 */
  1011		if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
  1012			vcpu_power_off(vcpu);
  1013		else
  1014			vcpu->arch.power_off = false;
  1015	
  1016		return 0;
  1017	}
  1018	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--YiEDa0DAkWCtVeE4
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
iHk8Ter/XKNaf6hNAQA=

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--YiEDa0DAkWCtVeE4--

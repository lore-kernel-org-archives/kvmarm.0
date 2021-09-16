Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2888FC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF07E6120D
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CF07E6120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 820F64B195;
	Thu, 16 Sep 2021 14:15:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tgS55cKh3E6d; Thu, 16 Sep 2021 14:15:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6863E4B0B8;
	Thu, 16 Sep 2021 14:15:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0872C4B092
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DFr4pIli69Ax for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:41 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D48444B090
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:41 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 f14-20020a056214076e00b003773e95910bso63229341qvz.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Pe7x0KqNWpd27U8B0VgFmhUlzq7CaBZRDC7FTGm6BYo=;
 b=c/zDfdFNoGgGDawStlpHk9tXybqTTvO3qklooPCSh2RZyn1jO926yAJN3EkzROcnWV
 +7Jv8frVlp+AjiKuCpYLQYVNhudtlSi3aG5XE0qVftcRBxmfkVHYUFK2g3I/ufLuYsD5
 yXWxHrl/35QQy9F3h5xRX4vnkMen65DAtcmDUlpWA2jh2qYxeZTWx7cuJq7rLgB37IjF
 FR1hGU1oD+z2TrGqXS1Hb1S8jn7kM7JHUntQZubO19eBArz72mowND7VvAXe/MPZogEM
 wCS3fOC64SO9FdoDCKIccrMyRTFwuxu7FOoW75kCgb27aM9H/lW5xEtfwu2ZTfFFx8KR
 /M9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Pe7x0KqNWpd27U8B0VgFmhUlzq7CaBZRDC7FTGm6BYo=;
 b=p+60dl+XJdprYNaSnBmCLMjhIlspOvpTAZ7GY9xgYTow0jaKyyHekSx3y2wkJuobgA
 q15glCl+aAJt6K0OVQyL29dwpt5WyO1vaRg3GBbdWgb6FOnt7G7EmhBYX30GtkoPhzvv
 7to8cAPCZghlCWnhrcbJV9/JmfUL365Owj5KMMW5S+qH0876LzncBJMcaEyRi1KKzmYa
 XnSHVn8YkKdN0XKP1+he0VHUXF/mAzgNTQCbIP6igf3lx3jWS81JZwyHP0kbpE0RhTH5
 g1BMAtmnlhu2HE1xMqeWjvXSyoklNcaFf2ngZmiT7XAbZbYaRCYiDhGVDPCBj3DtxdTw
 xK2w==
X-Gm-Message-State: AOAM530jx56Ppr23ZKTk1KMRwvGHmfkV6hnQojpQz5/twbaUHdH6wofG
 tXSoQGUlxgRX5MtjqIzac7VbmWzX9k4=
X-Google-Smtp-Source: ABdhPJyvIbX+FueQ86OOu11wGIo24Yj/vbCnWhhfcLYDpB8XPsQIlfG3Y+cSd9yAQkcLoDzHF5ajFaxNvtk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:9146:: with SMTP id
 q64mr6704127qvq.38.1631816141556; 
 Thu, 16 Sep 2021 11:15:41 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:31 +0000
Message-Id: <20210916181538.968978-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 0/7] KVM: x86: Add idempotent controls for migrating system
 counter state
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

KVM's current means of saving/restoring system counters is plagued with
temporal issues. On x86, we migrate the guest's system counter by-value
through the respective guest's IA32_TSC value. Restoring system counters
by-value is brittle as the state is not idempotent: the host system
counter is still oscillating between the attempted save and restore.
Furthermore, VMMs may wish to transparently live migrate guest VMs,
meaning that they include the elapsed time due to live migration blackout
in the guest system counter view. The VMM thread could be preempted for
any number of reasons (scheduler, L0 hypervisor under nested) between the
time that it calculates the desired guest counter value and when
KVM actually sets this counter state.

Despite the value-based interface that we present to userspace, KVM
actually has idempotent guest controls by way of the TSC offset.
We can avoid all of the issues associated with a value-based interface
by abstracting these offset controls in a new device attribute. This
series introduces new vCPU device attributes to provide userspace access
to the vCPU's system counter offset.

Patches 1-2 are Paolo's refactorings around locking and the
KVM_{GET,SET}_CLOCK ioctls.

Patch 3 cures a race where use_master_clock is read outside of the
pvclock lock in the KVM_GET_CLOCK ioctl.

Patch 4 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
ioctls to provide userspace with a (host_tsc, realtime) instant. This is
essential for a VMM to perform precise migration of the guest's system
counters.

Patch 5 does away with the pvclock spin lock in favor of a sequence
lock based on the tsc_write_lock. The original patch is from Paolo, I
touched it up a bit to fix a deadlock and some unused variables that
caused -Werror to scream.

Patch 6 extracts the TSC synchronization tracking code in a way that it
can be used for both offset-based and value-based TSC synchronization
schemes.

Finally, patch 7 implements a vCPU device attribute which allows VMMs to
get at the TSC offset of a vCPU.

This series was tested with the new KVM selftests for the KVM clock and
system counter offset controls on Haswell hardware. Kernel was built
with CONFIG_LOCKDEP given the new locking changes/lockdep assertions
here.

Note that these tests are mailed as a separate series due to the
dependencies in both x86 and arm64.

Applies cleanly to 5.15-rc1

v8: http://lore.kernel.org/r/20210816001130.3059564-1-oupton@google.com

v7 -> v8:
 - Rebased to 5.15-rc1
 - Picked up Paolo's version of the series, which includes locking
   changes
 - Make KVM advertise KVM_CAP_VCPU_ATTRIBUTES

Oliver Upton (4):
  KVM: x86: Fix potential race in KVM_GET_CLOCK
  KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
  KVM: x86: Refactor tsc synchronization code
  KVM: x86: Expose TSC offset controls to userspace

Paolo Bonzini (3):
  kvm: x86: abstract locking around pvclock_update_vm_gtod_copy
  KVM: x86: extract KVM_GET_CLOCK/KVM_SET_CLOCK to separate functions
  kvm: x86: protect masterclock with a seqcount

 Documentation/virt/kvm/api.rst          |  42 ++-
 Documentation/virt/kvm/devices/vcpu.rst |  57 +++
 arch/x86/include/asm/kvm_host.h         |  12 +-
 arch/x86/include/uapi/asm/kvm.h         |   4 +
 arch/x86/kvm/x86.c                      | 458 ++++++++++++++++--------
 include/uapi/linux/kvm.h                |   7 +-
 6 files changed, 419 insertions(+), 161 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

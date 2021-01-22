Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BB6C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 10:14:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7053235F9
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 10:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7053235F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 591714B1AD;
	Fri, 22 Jan 2021 05:14:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4DMkRXuCviYE; Fri, 22 Jan 2021 05:14:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E22214B19E;
	Fri, 22 Jan 2021 05:14:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA9994B18B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 05:14:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgGT-ePv2F4q for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 05:14:14 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CF534B194
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 05:14:14 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DMZp50tyzz15xFK;
 Fri, 22 Jan 2021 18:13:01 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 22 Jan 2021 18:14:02 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 0/2] Some optimization for stage-2 translation
Date: Fri, 22 Jan 2021 18:13:56 +0800
Message-ID: <20210122101358.379956-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
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

Hi, Will, Marc,
Is there any further comment on the v3 series I post previously?
If they are not fine to you, then I think maybe we should just turn
back to the original solution in v1, where I suggestted to filter out
the case of only updating access permissions in the map handler and
handle it right there.

Here are the reasons for my current opinion:
With an errno returned from the map handler for this single case, there
will be one more vcpu exit from guest and we also have to consider the
spurious dirty pages. Besides, it seems that the EAGAIN errno has been
chosen specially for this case and can not be used elsewhere for other
reasons, as we will change this errno to zero at the end of the function.

The v1 solution looks like more concise at last, so I refine the diff
and post the v4 with two patches here, just for a contrast.

Which solution will you prefer now? Could you please let me know.

Thanks,
Yanan.

Links:
v1: https://lore.kernel.org/lkml/20201211080115.21460-1-wangyanan55@huawei.com
v2: https://lore.kernel.org/lkml/20201216122844.25092-1-wangyanan55@huawei.com
v3: https://lore.kernel.org/lkml/20210114121350.123684-1-wangyanan55@huawei.com

---

About patch-1:
Procedures of hyp stage-1 map and guest stage-2 map are quite different,
but they are now tied closely by function kvm_set_valid_leaf_pte().
So adjust the relative code for ease of code maintenance in the future.

About patch-2:
(1) During running time of a a VM with numbers of vCPUs, if some vCPUs
access the same GPA almost at the same time and the stage-2 mapping of
the GPA has not been built yet, as a result they will all cause
translation faults. The first vCPU builds the mapping, and the followed
ones end up updating the valid leaf PTE. Note that these vCPUs might
want different access permissions (RO, RW, RX, RWX, etc.).

(2) It's inevitable that we sometimes will update an existing valid leaf
PTE in the map path, and we all perform break-before-make in this case.
Then more unnecessary translation faults could be caused if the
*break stage* of BBM is just catched by other vCPUs.

With (1) and (2), something unsatisfactory could happen: vCPU A causes
a translation fault and builds the mapping with RW permissions, vCPU B
then update the valid leaf PTE with break-before-make and permissions
are updated back to RO. Besides, *break stage* of BBM may trigger more
translation faults. Finally, some useless small loops could occur.

We can make some optimization to solve above problems: When we need to
update a valid leaf PTE in the translation fault handler, let's filter
out the case where this update only change access permissions that don't
require break-before-make. If there have already been the permissions
we want, don't bother to update. If still more permissions need to be
added, then update the PTE directly without break-before-make.

---

Changelogs

v4->v3:
- Turn back to the original solution in v1 and refine the diff
- Rebased on top of v5.11-rc4

v2->v3:
- Rebased on top of v5.11-rc3
- Refine the commit messages
- Make some adjustment about return value in patch-2 and patch-3

v1->v2:
- Make part of the diff a seperate patch (patch-1)
- Add Will's Signed-off-by for patch-1
- Return an errno when meeting changing permissions case in map path
- Add a new patch (patch-3)

---

Yanan Wang (2):
  KVM: arm64: Adjust partial code of hyp stage-1 map and guest stage-2
    map
  KVM: arm64: Filter out the case of only changing permissions from
    stage-2 map path

 arch/arm64/include/asm/kvm_pgtable.h |  4 ++
 arch/arm64/kvm/hyp/pgtable.c         | 88 +++++++++++++++++++---------
 2 files changed, 63 insertions(+), 29 deletions(-)

-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

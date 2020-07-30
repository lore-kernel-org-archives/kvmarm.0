Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E15C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 14:20:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC66F20829
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 14:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC66F20829
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1616F4B505;
	Thu, 30 Jul 2020 10:20:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l99kqMWW824u; Thu, 30 Jul 2020 10:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E30264B504;
	Thu, 30 Jul 2020 10:20:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07AD84B504
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 10:20:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fnmGqYD6t-pW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 10:20:05 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 618D24B4FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 10:20:05 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 45E8DC7AD72D78B946C1;
 Thu, 30 Jul 2020 22:19:58 +0800 (CST)
Received: from [127.0.0.1] (10.174.186.173) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0;
 Thu, 30 Jul 2020 22:19:49 +0800
From: Zhenyu Ye <yezhenyu2@huawei.com>
Subject: [Question] the check of ioeventfd collision in
 kvm_*assign_ioeventfd_idx
To: <pbonzini@redhat.com>, <mst@redhat.com>, <gleb@redhat.com>,
 <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Xiexiangyou
 <xiexiangyou@huawei.com>, <ghaskins@novell.com>
Message-ID: <bbece68b-fb39-d599-9ba7-a8ee8be16525@huawei.com>
Date: Thu, 30 Jul 2020 22:19:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
X-Originating-IP: [10.174.186.173]
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

Hi all,

There are checks of ioeventfd collision in both kvm_assign_ioeventfd_idx()
and kvm_deassign_ioeventfd_idx(), however, with different logic.

In kvm_assign_ioeventfd_idx(), this is done by ioeventfd_check_collision():
---8<---
	if (_p->bus_idx == p->bus_idx &&
	    _p->addr == p->addr &&
	    (!_p->length || !p->length ||
	     (_p->length == p->length &&
	      (_p->wildcard || p->wildcard ||
	       _p->datamatch == p->datamatch))))
		// then we consider the two are the same
---8<---

The logic in kvm_deassign_ioeventfd_idx() is as follows:
---8<---
	if (p->bus_idx != bus_idx ||
	    p->eventfd != eventfd  ||
	    p->addr != args->addr  ||
	    p->length != args->len ||
	    p->wildcard != wildcard)
		continue;

	if (!p->wildcard && p->datamatch != args->datamatch)
		continue;

	// then we consider the two are the same
---8<---

As we can see, there is extra check of p->eventfd in

().  Why we don't check p->eventfd
in kvm_assign_ioeventfd_idx()? Or should we delete this in
kvm_deassign_ioeventfd_idx()?


Thanks,
Zhenyu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=/xEG=3D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF569C33CB1
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jan 2020 14:21:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7DE1624672
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jan 2020 14:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DE1624672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 083744AF4F;
	Tue, 14 Jan 2020 09:21:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZlggzCrz6H3h; Tue, 14 Jan 2020 09:21:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59A2C4AFB8;
	Tue, 14 Jan 2020 09:21:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D7454AFB8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 09:21:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bmdah23n8uXK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jan 2020 09:21:01 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59B004AF4F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jan 2020 09:21:01 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 305A29FA6ADF3375DD5C;
 Tue, 14 Jan 2020 22:20:57 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 14 Jan 2020
 22:20:48 +0800
To: Marc Zyngier <maz@kernel.org>, "Tangnianyao (ICT)"
 <tangnianyao@huawei.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <fanhenglong@huawei.com>,
 <wanghaibin.wang@huawei.com>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [Question about KVM on arm64] Consider putting VINVALL to deactivation
Message-ID: <bf470803-8e1c-d1c3-d5ac-731536196543@hisilicon.com>
Date: Tue, 14 Jan 2020 22:20:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Cc: Lizixian <lizixian@hisilicon.com>, wangwudi <wangwudi@hisilicon.com>,
 jiayanlei@huawei.com
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


Hi Marc,

On activation, VMAPP command is followed by a VINVALL, which could be quite expensive
for the start-up of virtual machine. If a vpeid is allowed successfully, it is not
used in system. We may consider put VINVALL to deactivation to ensure all cache of
certain vpeid is invalid, to simplify activation. We consider start-up may be more
common and more time-consuming-sensitive than shutdown process.

Do you think it's all right?

Thanks,
Shaokun

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

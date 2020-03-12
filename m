Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71C6C1975A
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:20:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69ED4206F1
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69ED4206F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8B7A4A32E;
	Thu, 12 Mar 2020 05:20:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8jDqtkH2JZ1F; Thu, 12 Mar 2020 05:20:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 971874A4F7;
	Thu, 12 Mar 2020 05:20:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3784A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:20:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dSs2iKBE3CZ1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 05:20:11 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72C4E4A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:20:08 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id EDEF9ED6D8587C08CEB4;
 Thu, 12 Mar 2020 17:20:04 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Mar 2020
 17:19:54 +0800
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To: Marc Zyngier <maz@kernel.org>, Auger Eric <eric.auger@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
 <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
Date: Thu, 12 Mar 2020 17:19:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020/3/11 22:00, Marc Zyngier wrote:
> That is still a problem with the ITS. There is no architectural way
> to report an error, even if the error numbers are architected...
> 
> One thing we could do though is to implement the stall model (as described
> in 5.3.2). It still doesn't give us the error, but at least the command
> queue would stop on detecting an error.

It would be interesting to see the buggy guest's behavior under the
stall mode. I've used the following diff (absolutely *not* a formal
patch, don't handle CREADR.Stalled and CWRITER.Retry at all) to have
a try, and caught another command error in the 'its-trigger' test.

logs/its-trigger.log:
" INT dev_id=2 event_id=20
lib/arm64/gic-v3-its-cmd.c:194: assert failed: false: INT timeout! "

dmesg:
[13297.711958] ------------[ cut here ]------------
[13297.711964] ITS command error encoding 0x10307

It's the last INT test in test_its_trigger() who has triggered this
error, Eric?


Thanks.

---8<---
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9d53f545a3d5..5717f5da0f22 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -179,6 +179,7 @@ struct vgic_its {
  	u64			cbaser;
  	u32			creadr;
  	u32			cwriter;
+	bool			stalled;

  	/* migration ABI revision in use */
  	u32			abi_rev;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d53d34a33e35..72422b75e627 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1519,6 +1519,9 @@ static void vgic_its_process_commands(struct kvm 
*kvm, struct vgic_its *its)
  	if (!its->enabled)
  		return;

+	if (unlikely(its->stalled))
+		return;
+
  	cbaser = GITS_CBASER_ADDRESS(its->cbaser);

  	while (its->cwriter != its->creadr) {
@@ -1531,9 +1534,34 @@ static void vgic_its_process_commands(struct kvm 
*kvm, struct vgic_its *its)
  		 * According to section 6.3.2 in the GICv3 spec we can just
  		 * ignore that command then.
  		 */
-		if (!ret)
-			vgic_its_handle_command(kvm, its, cmd_buf);
+		if (ret)
+			goto done;
+
+		ret = vgic_its_handle_command(kvm, its, cmd_buf);
+
+		/*
+		 * Choose the stall mode on detection of command errors.
+		 * Guest still can't get the architected error numbers though...
+		 */
+		if (ret) {
+			/* GITS_CREADR.Stalled is set to 1. */
+			its->stalled = true;
+
+			/*
+			 * GITS_TYPER.SEIS is 0 atm, no System error will be
+			 * generated.  Instead report error encodings at ITS
+			 * level.
+			 */
+			WARN_RATELIMIT(ret, "ITS command error encoding 0x%x", ret);
+
+			/*
+			 * GITS_CREADR is not incremented and continues to
+			 * point to the entry that triggered the error.
+			 */
+			break;
+		}

+done:
  		its->creadr += ITS_CMD_SIZE;
  		if (its->creadr == ITS_CMD_BUFFER_SIZE(its->cbaser))
  			its->creadr = 0;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

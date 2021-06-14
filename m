Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8A8C48BE8
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 02:54:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E192613AB
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 02:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E192613AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B603D40623;
	Sun, 13 Jun 2021 22:54:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I4VIFRldDNBx; Sun, 13 Jun 2021 22:54:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B707B4A2E5;
	Sun, 13 Jun 2021 22:54:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47CF640630
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Jun 2021 22:54:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lD5fcUCTMSNq for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Jun 2021 22:54:03 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D58740762
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Jun 2021 22:54:03 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 s5-20020aa78d450000b02902ace63a7e93so7472055pfe.8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Jun 2021 19:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=G0BvcWLb4IeXiMagmDzrz7Uqmh6mNFjQeYSUfBYTeS0=;
 b=J5d2R6fWgIT7owLOkJV6VeWqsPNmA3XhITMy2ACzrDEZhT0Hlwu1Mv1CGvxmT9xZEJ
 zOh45iAE5qCbYIz/1wXZBdrottBUD7tpMTeePsXb7v9pq1MVKNz/w44zNDX5DV7GJSNw
 tUg2JDh1hnHw8Fct0UeMIcmZl+UUTt3HJqYS4yXoEOYYItYDzo+7W04DATqfZNjGj0EE
 FJ4jtuO3fwrMXv+WswutYrXdpiDAx3BQTTnr1PTdXUUB8IPOb33aV1KfvgYWQbQSHSW+
 jN4K6ERakZJxjI6TqbwlCEllee61z7OrSO6pbKuyV3wieGgx7IAhVQP6z/uCtPoNXmQE
 gfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=G0BvcWLb4IeXiMagmDzrz7Uqmh6mNFjQeYSUfBYTeS0=;
 b=Jf0m3H6XI8aUqVogDgNqySvlLJVGgMnE7s2eAuU/2eEbat6cLzMAjDI5pCNIappIfT
 84TSUzzdRmz3F9v3WCRepXGwNSwRiRTVjFkvg3kECcIRaO1/DYRzDE2H4aDAVuerftVS
 fKJGBVxtpcK/LwZ9xCrKOx9i8lT9c2Kp3gh2h19nkRRpz8enABq+oGuRDGUIjdEcIeK6
 GE8VltYAMhJcx3kerjqXXYy0OCNGT3cqiITNXBHhcN/CpOoJTTc5JygukaNlBs/TIMMY
 qIQYPgv0GA05iV7OmVvdAGaFkj3h1E6VjSzkuHaTcC20dIPiOb9NTn9PePiFg4OUJtnH
 RAww==
X-Gm-Message-State: AOAM532sudlDsEJiYCSELAVnCddQmJouzr7mU8h+fKymDspMKvc/W1aj
 9tjFrKLLbi7PIgJqg+o3XEf2YIMfNTcjgIiE5g==
X-Google-Smtp-Source: ABdhPJycgiFSbxMZLS8Bil1CYzhmeCE7vWg07Yh1drE2XVuoYrfaHxoRxI6LH8bCvEcGVqokSkYhAgwO3CRfAtV4/A==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:ed4d:: with SMTP id
 m13mr15005137pgk.433.1623639242315; Sun, 13 Jun 2021 19:54:02 -0700 (PDT)
Date: Mon, 14 Jun 2021 02:53:51 +0000
In-Reply-To: <20210614025351.365284-1-jingzhangos@google.com>
Message-Id: <20210614025351.365284-5-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 4/4] KVM: selftests: Update binary stats test for stats mode
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>, 
 LinuxS390 <linux-s390@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Fuad Tabba <tabba@google.com>
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

Update binary stats selftest to support sanity test for stats
read/write mode and offset.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/kvm_binary_stats_test.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index d85859a6815a..2a34b5e822e8 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -77,6 +77,8 @@ static void stats_test(int stats_fd)
 				<= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
 		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK)
 				<= KVM_STATS_BASE_MAX, "Unknown KVM stats base");
+		TEST_ASSERT((pdesc->flags & KVM_STATS_MODE_MASK)
+				<= KVM_STATS_MODE_MAX, "Unknown KVM stats mode");
 		/* Check exponent for stats unit
 		 * Exponent for counter should be greater than or equal to 0
 		 * Exponent for unit bytes should be greater than or equal to 0
@@ -106,11 +108,18 @@ static void stats_test(int stats_fd)
 	}
 	/* Check overlap */
 	TEST_ASSERT(header->data_offset >= header->desc_offset
-			|| header->data_offset + size_data <= header->desc_offset,
-			"Data block is overlapped with Descriptor block");
+		|| header->data_offset + size_data <= header->desc_offset,
+		"Data block is overlapped with Descriptor block");
 	/* Check validity of all stats data size */
 	TEST_ASSERT(size_data >= header->count * sizeof(stats_data->value[0]),
 			"Data size is not correct");
+	/* Check stats offset */
+	for (i = 0; i < header->count; ++i) {
+		pdesc = (void *)stats_desc + i * size_desc;
+		TEST_ASSERT(pdesc->offset < size_data,
+			"Invalid offset (%u) for stats: %s",
+			pdesc->offset, pdesc->name);
+	}
 
 	/* Allocate memory for stats data */
 	stats_data = malloc(size_data);
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

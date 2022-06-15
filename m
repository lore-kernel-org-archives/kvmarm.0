Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497A7CCA473
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jun 2022 19:31:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3044B32D;
	Wed, 15 Jun 2022 15:31:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OdyRLmH6yy0o; Wed, 15 Jun 2022 15:31:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79E7E4B329;
	Wed, 15 Jun 2022 15:31:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 684844B0B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qiuj3FONRyqf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jun 2022 15:31:34 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D3EC4B1FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 15:31:34 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 p143-20020a25d895000000b006648c7235a6so10363074ybg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jun 2022 12:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0A1qUobQisYFir8bSqnJq36CQ0mNNtlgbs2SvOAwXHc=;
 b=bCrCYBvAVJ0y9knJ7QoMwIeTYXyOw5k/4LkQcVf0DA/Yr8hb3yW/EgVWEv8valPkm8
 U4svsfa3sLOe1UCzmLIXirRpvkijJ4/5AqxlWOdebDyGc/+VUvhKUHom4CroL00WVP1r
 Zt++yo/4GAyKr2NIuzZcWFegc1x2B3sGI1VUIPt1ksp09TutxZREOyldn6VFPZsWCrtR
 l4LGYraLm64GnCpy2fUgxby76+e/rwy8XMNm8bzF/lmnIsyCDU7g2EYFAj7UT+a1CRCm
 FF7nv4Ddtbtcb9kIgHsRN6srMWtxGKYFdXzTsm/cplt1sKcPfDrRuk3CsjRsKbKnWC+w
 lKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0A1qUobQisYFir8bSqnJq36CQ0mNNtlgbs2SvOAwXHc=;
 b=24kV+b0CUd8iXicJqzUt5+IKbATFLYrF2Q1hN/+032ngykr1+IfX1vpfFoksQcvEaj
 ynQ2Cuaor+6Fq9DgI7/FmYI1GIY1rJ4jBhg0oNG0cTxv6EmcbCVKhyRH5CyRe6lO9FD+
 /Ds7w11nDGJ9mdHCLMgfI+F5U5794m/wvEcjoME+gB9dAvlkFqbOs5fEhTldqeoQrc2J
 jkh8yNkmFgUFzKNFBjGavJdtT11zC4zi7i5ts7mB02RXUgA5vangVXUh36q+pCUaSfzm
 x4+WnFK0oAYaUpeRpxz1mlrsHlipcYxIfOr8HxYQ4R7RtISSASPe5Dyi7C/AbIGVm4Qe
 0uHg==
X-Gm-Message-State: AJIora9KXlRZMBBP2pdYrT9e+nvrP4Bj3ePlY8rGUA9mGw9sJRTPLGwh
 U9bum4rr0K5feAFAIY92v858D5w3ensSd5wxFQ==
X-Google-Smtp-Source: AGRyM1sFpUaVIm0gUXUCuBF8nXSdLidTfcGiqvEhvoTkkRBFVlcKYuhXbB7NYKNV0DsIASsf2o84Kvj0GtDCb8zK2Q==
X-Received: from coltonlewis-kvm.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:4992:0:b0:30c:1b61:82ac with SMTP
 id w140-20020a814992000000b0030c1b6182acmr1399797ywa.348.1655321494001; Wed,
 15 Jun 2022 12:31:34 -0700 (PDT)
Date: Wed, 15 Jun 2022 19:31:13 +0000
In-Reply-To: <20220615193116.806312-1-coltonlewis@google.com>
Message-Id: <20220615193116.806312-2-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 1/4] KVM: selftests: enumerate GUEST_ASSERT arguments
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
Cc: thuth@redhat.com, Colton Lewis <coltonlewis@google.com>, maz@kernel.org,
 vkuznets@redhat.com
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

Enumerate GUEST_ASSERT arguments to avoid magic indices to ucall.args.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/include/ucall_common.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 98562f685151..dbe872870b83 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -32,6 +32,14 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
+
+enum guest_assert_builtin_args {
+	GUEST_ERROR_STRING,
+	GUEST_FILE,
+	GUEST_LINE,
+	GUEST_ASSERT_BUILTIN_NARGS
+};
+
 #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
 	if (!(_condition))                                              \
 		ucall(UCALL_ABORT, 2 + _nargs,                          \
-- 
2.36.1.476.g0c4daa206d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

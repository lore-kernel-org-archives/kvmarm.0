Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222A0C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B297A60FED
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 11:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B297A60FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E594B298;
	Fri, 12 Nov 2021 06:47:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ur-+DFbpP5eh; Fri, 12 Nov 2021 06:47:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 364254B296;
	Fri, 12 Nov 2021 06:47:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C244B291
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oL9ReuBYDu73 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 06:47:37 -0500 (EST)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D54214B288
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:47:36 -0500 (EST)
Received: by mail-wm1-f48.google.com with SMTP id
 c71-20020a1c9a4a000000b0032cdcc8cbafso6538459wme.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 03:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=wIGpUqKKsdBHIVu7qLREHVQ4Ti/omu4NC8RNTDPGi9k=;
 b=vj2y4YrzQqksYHFE33XVZ3whLo3Chi4yrXCxl7Zy/f2tOEeUlTog/fLlj88qlAPiY8
 uMM539hoRcocmCg108gpHECMDvof/LYSZNr/jPZ2vukiExcLgxs2z1RvXdozoRfbxORA
 44VpQ2vS+n3E9P9a1JwLQHXdTjQm1/wNh+83ccPR1sVoT+GlM5snCCbJknbIgnXpzSit
 hmlm3R70Q+mA/3w6YI37GLKjB5LAGu2+wHggWgMJI+FWtNZO5xb3tv/u8+sDTEtF2XP4
 Ak6acw2EJOQZeRiYPU06WMNZGHISBo6kbECUA045yPrf7jkVw3fXpxFWmIdwp9X9a1p3
 6taA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=wIGpUqKKsdBHIVu7qLREHVQ4Ti/omu4NC8RNTDPGi9k=;
 b=Hb/KVTqSbswjO5Gt+4asuVBNVlnH49b9aoERoDSKN69h+njzyfoELF7lfdQk9U/l4Y
 xwg8kmAfaO7jKdAJlu7V5NCpr4PYEsHiVgEUhRFIMKlzNqTV182aivkALsMoYg51n0A0
 cpdVpOnQ9QvSGxJlHWSiF9x8+luyWCMHLXQAhAvi21bbRIRMBObdp+gM4M6ownBJrL9E
 Towd/Zm3GIZnYrkQNAFDqdl282cjm1cXQpm3qvOrIkh/BEpegHArgDHUC2hqeuMvKe0G
 czHSUpftLY9AGg3ho4En2n/Yb8Bu+8iaP8zr8ZqSH3pY2+Y70S22QOwHyL6mWKPhecXM
 ZvPg==
X-Gm-Message-State: AOAM530PsmWhTTRZ4ZvdeVxxKX+ydU1GeT71hcfziSDTRjYHn5P+I/xn
 gwAoAKhymTsvgX5FoWsTGgdtIA==
X-Google-Smtp-Source: ABdhPJyENsuVXPYwrdzvRDQJQgMZaKOk+plTsoN67GYhMD9w1WdUkbkFRgRwdFvp07nDvh+ZSFMfsw==
X-Received: by 2002:a1c:2b04:: with SMTP id r4mr35189034wmr.48.1636717655778; 
 Fri, 12 Nov 2021 03:47:35 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id j40sm6114775wms.16.2021.11.12.03.47.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 03:47:34 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 5F2261FF98;
 Fri, 12 Nov 2021 11:47:34 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 1/3] arm64: remove invalid check from
 its-trigger test
Date: Fri, 12 Nov 2021 11:47:32 +0000
Message-Id: <20211112114734.3058678-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112114734.3058678-1-alex.bennee@linaro.org>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

V2hpbGUgYW4gSVJRIGlzIG5vdCAiZ3VhcmFudGVlZCB0byBiZSB2aXNpYmxlIHVudGlsIGFuIGFw
cHJvcHJpYXRlCmludmFsaWRhdGlvbiIgaXQgZG9lc24ndCBzdG9wIHRoZSBhY3R1YWwgaW1wbGVt
ZW50YXRpb24gZGVsaXZlcmluZyBpdAplYXJsaWVyIGlmIGl0IHdhbnRzIHRvLiBUaGlzIGlzIHRo
ZSBjYXNlIGZvciBRRU1VJ3MgVENHIGFuZCBhcyB0ZXN0cwpzaG91bGQgb25seSBiZSBjaGVja2lu
ZyBhcmNoaXRlY3R1cmFsIGNvbXBsaWFuY2UgdGhpcyBjaGVjayBpcwppbnZhbGlkLgoKU2lnbmVk
LW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpSZXZpZXdlZC1i
eTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpDYzogU2hhc2hpIE1hbGxlbGEg
PHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Ck1lc3NhZ2UtSWQ6IDwyMDIxMDUyNTE3MjYyOC4y
MDg4LTItYWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tLQp2MwogIC0gcmVmbG93IHRoZSBjb21t
ZW50LCBkcm9wICJ3aWxsaW5nbHkgZG8gbm90IGNhbGwiIGFzIHBlciBFcmljJ3Mgc3VnZ2VzdGlv
bgotLS0KIGFybS9naWMuYyB8IDE2ICsrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2
IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FybS9naWMuYyBi
L2FybS9naWMuYwppbmRleCA5ODEzNWVmLi4xZTNlYTgwIDEwMDY0NAotLS0gYS9hcm0vZ2ljLmMK
KysrIGIvYXJtL2dpYy5jCkBAIC03MzIsMjEgKzczMiwxNyBAQCBzdGF0aWMgdm9pZCB0ZXN0X2l0
c190cmlnZ2VyKHZvaWQpCiAJCQkiZGV2Mi9ldmVudGlkPTIwIGRvZXMgbm90IHRyaWdnZXIgYW55
IExQSSIpOwogCiAJLyoKLQkgKiByZS1lbmFibGUgdGhlIExQSSBidXQgd2lsbGluZ2x5IGRvIG5v
dCBjYWxsIGludmFsbAotCSAqIHNvIHRoZSBjaGFuZ2UgaW4gY29uZmlnIGlzIG5vdCB0YWtlbiBp
bnRvIGFjY291bnQuCi0JICogVGhlIExQSSBzaG91bGQgbm90IGhpdAorCSAqIHJlLWVuYWJsZSB0
aGUgTFBJLiBXaGlsZSAiQSBjaGFuZ2UgdG8gdGhlIExQSSBjb25maWd1cmF0aW9uCisJICogaXMg
bm90IGd1YXJhbnRlZWQgdG8gYmUgdmlzaWJsZSB1bnRpbCBhbiBhcHByb3ByaWF0ZQorCSAqIGlu
dmFsaWRhdGlvbiBvcGVyYXRpb24gaGFzIGNvbXBsZXRlZCIgaGFyZHdhcmUgdGhhdCBkb2Vzbid0
CisJICogaW1wbGVtZW50IGNhY2hlcyBtYXkgaGF2ZSBkZWxpdmVyZWQgdGhlIGV2ZW50IGF0IGFu
eSBwb2ludAorCSAqIGFmdGVyIHRoZSBlbmFibGluZy4gQ2hlY2sgdGhlIExQSSBoYXMgaGl0IGJ5
IHRoZSB0aW1lIHRoZQorCSAqIGludmFsbCBpcyBkb25lLgogCSAqLwogCWdpY3YzX2xwaV9zZXRf
Y29uZmlnKDgxOTUsIExQSV9QUk9QX0RFRkFVTFQpOwogCXN0YXRzX3Jlc2V0KCk7CiAJY3B1bWFz
a19jbGVhcigmbWFzayk7CiAJaXRzX3NlbmRfaW50KGRldjIsIDIwKTsKLQl3YWl0X2Zvcl9pbnRl
cnJ1cHRzKCZtYXNrKTsKLQlyZXBvcnQoY2hlY2tfYWNrZWQoJm1hc2ssIC0xLCAtMSksCi0JCQki
ZGV2Mi9ldmVudGlkPTIwIHN0aWxsIGRvZXMgbm90IHRyaWdnZXIgYW55IExQSSIpOwotCi0JLyog
Tm93IGNhbGwgdGhlIGludmFsbCBhbmQgY2hlY2sgdGhlIExQSSBoaXRzICovCi0Jc3RhdHNfcmVz
ZXQoKTsKLQljcHVtYXNrX2NsZWFyKCZtYXNrKTsKIAljcHVtYXNrX3NldF9jcHUoMywgJm1hc2sp
OwogCWl0c19zZW5kX2ludmFsbChjb2wzKTsKIAl3YWl0X2Zvcl9pbnRlcnJ1cHRzKCZtYXNrKTsK
LS0gCjIuMzAuMgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

Return-Path: <SRS0=drPj=KU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FF0C2B9F8
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2EC961404
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:26:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2EC961404
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 946954099E;
	Tue, 25 May 2021 13:26:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZiIG9zo7zPZd; Tue, 25 May 2021 13:26:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 576914B0C2;
	Tue, 25 May 2021 13:26:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83668407D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZXaYT8GPC+OE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 May 2021 13:26:36 -0400 (EDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2837C4B0C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:26:35 -0400 (EDT)
Received: by mail-wm1-f42.google.com with SMTP id z130so17196616wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=8vhxbSb0kOGC8+nQM9S+UwSASWSZTJvJYDcePLw1qik=;
 b=DvkmYHVn3HaRgZzPceU2GhR2wTdg+bNlZ8zWdNizKPR5jm/SkWQSY1j8trE6BlsdDQ
 OBsU5vB5YZDLMDteDH80B5XFp14rtd//uQrxUV8pD6J3FPQv2ruiqlq+m/ySrzTYNCK4
 v3XUJkSWiUQikJioCoUPTH58TJV4co8CCV/V/n7xbCMLd611nyRR6FWkN01WytKVXR61
 waIDp54ysmCOksR1TNsGmp2n2Td+0vL+VhAq+LSI0Jt8Kfi2ysCW3/B0yIzF62CS/0wh
 eKc6SeUh8Lv+brC/Ubivypvjpu0AKAYIeSqmmI9wJw2o8iFdKTKoo1K3rwu3lVoRVp2k
 GyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=8vhxbSb0kOGC8+nQM9S+UwSASWSZTJvJYDcePLw1qik=;
 b=WhoVejTlknvQofRHmHH22uDodMdKiwaasLGW1H1j1kZItGRgE/bPsL1L1nwUv0C8yp
 Bne66P6rihWcnQiZpKWkiUkSKyMjHP2ZjTw81iJ+AHUCYVUIPqZRWahI/8hmOZ2QoXm2
 Qkhr/Vw6VtjkVWhSwSh+6L8Fevd3lsJQBHeBiEqlnPnHx7Zbyeaey6+l8Y4psX7EfZCV
 imNj1/sHcYuyBdZ2hAjuILITyf6YUC96BcqByFldYbuP8cn/BwQyBohnAijpkF8LL783
 pLM2yX+vcoF5FsT+hTzyWMsonkHwI4eeDx2zgy0c0pzfGuS4FrqdLoCb1315yBcbNqWE
 JWCQ==
X-Gm-Message-State: AOAM531anPojccQNznxPGan00BGd9+FzDkEXxLVsDvK99bdJJmpPHA08
 zpjc3faonNXXpN/89erWOZ2eyQ==
X-Google-Smtp-Source: ABdhPJwJcS6ubLrQtKSjUB+dF+9hCxd+Me0VaOsHNU0DUOoeSkOw+4jNx+Dkf/HE7m6wlUQVP4fjaw==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr4950802wml.84.1621963594304;
 Tue, 25 May 2021 10:26:34 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id k132sm3533580wma.34.2021.05.25.10.26.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 May 2021 10:26:29 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id A4E181FF90;
 Tue, 25 May 2021 18:26:28 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Date: Tue, 25 May 2021 18:26:28 +0100
Message-Id: <20210525172628.2088-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525172628.2088-1-alex.bennee@linaro.org>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
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

V2hlbiBydW5uaW5nIHRoZSB0ZXN0IGluIFRDRyB3ZSBhcmUgYmFzaWNhbGx5IHJ1bm5pbmcgb24g
YmFyZSBtZXRhbCBzbwpkb24ndCByZWx5IG9uIGhhdmluZyBhIHBhcnRpY3VsYXIga2VybmVsIGVy
cmF0YSBhcHBsaWVkLgoKWW91IG1pZ2h0IHdvbmRlciB3aHkgd2UgaGFuZGxlIHRoaXMgd2l0aCBh
IHRvdGFsbHkgbmV3IHRlc3QgbmFtZQppbnN0ZWFkIG9mIGFkanVzdGluZyB0aGUgYXBwZW5kIHRv
IHRha2UgYW4gZXh0cmEgcGFyYW1ldGVyPyBXZWxsIHRoZQpydW5fbWlncmF0aW9uIHNoZWxsIHNj
cmlwdCB1c2VzIGV2YWwgIiRAIiB3aGljaCB1bndyYXBzIHRoZSAtYXBwZW5kCmxlYWRpbmcgdG8g
YW55IHNlY29uZCBwYXJhbWV0ZXIgYmVpbmcgc3BsaXQgYW5kIGxlYXZpbmcgUUVNVSB2ZXJ5CmNv
bmZ1c2VkIGFuZCB0aGUgdGVzdCBoYW5naW5nLiBUaGlzIHNlZW1lZCBzaW1wbGVyIHRoYW4gcmUt
d3JpdGluZyBhbGwKdGhlIHRlc3QgcnVubmluZyBsb2dpYyBpbiBzb21ldGhpbmcgc2FuZSA7LSkK
ClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KQ2M6
IFNoYXNoaSBNYWxsZWxhIDxzaGFzaGkubWFsbGVsYUBsaW5hcm8ub3JnPgotLS0KIGFybS9naWMu
YyAgICAgICAgIHwgIDggKysrKysrKy0KIGFybS91bml0dGVzdHMuY2ZnIHwgMTAgKysrKysrKysr
LQogMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2FybS9naWMuYyBiL2FybS9naWMuYwppbmRleCBiZWYwNjFhLi4wZmNlMmE0IDEw
MDY0NAotLS0gYS9hcm0vZ2ljLmMKKysrIGIvYXJtL2dpYy5jCkBAIC0zNiw2ICszNiw3IEBAIHN0
YXRpYyBzdHJ1Y3QgZ2ljICpnaWM7CiBzdGF0aWMgaW50IGFja2VkW05SX0NQVVNdLCBzcHVyaW91
c1tOUl9DUFVTXTsKIHN0YXRpYyBpbnQgaXJxX3NlbmRlcltOUl9DUFVTXSwgaXJxX251bWJlcltO
Ul9DUFVTXTsKIHN0YXRpYyBjcHVtYXNrX3QgcmVhZHk7CitzdGF0aWMgYm9vbCB1bmRlcl90Y2c7
CiAKIHN0YXRpYyB2b2lkIG5yX2NwdV9jaGVjayhpbnQgbnIpCiB7CkBAIC04MzQsNyArODM1LDcg
QEAgc3RhdGljIHZvaWQgdGVzdF9taWdyYXRlX3VubWFwcGVkX2NvbGxlY3Rpb24odm9pZCkKIAkJ
Z290byBkb19taWdyYXRlOwogCX0KIAotCWlmICghZXJyYXRhKEVSUkFUQV9VTk1BUFBFRF9DT0xM
RUNUSU9OUykpIHsKKwlpZiAoIWVycmF0YShFUlJBVEFfVU5NQVBQRURfQ09MTEVDVElPTlMpICYm
ICF1bmRlcl90Y2cpIHsKIAkJcmVwb3J0X3NraXAoIlNraXBwaW5nIHRlc3QsIGFzIHRoaXMgdGVz
dCBoYW5ncyB3aXRob3V0IHRoZSBmaXguICIKIAkJCSAgICAiU2V0ICVzPXkgdG8gZW5hYmxlLiIs
IEVSUkFUQV9VTk1BUFBFRF9DT0xMRUNUSU9OUyk7CiAJCXRlc3Rfc2tpcHBlZCA9IHRydWU7CkBA
IC0xMDA1LDYgKzEwMDYsMTEgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCQly
ZXBvcnRfcHJlZml4X3B1c2goYXJndlsxXSk7CiAJCXRlc3RfbWlncmF0ZV91bm1hcHBlZF9jb2xs
ZWN0aW9uKCk7CiAJCXJlcG9ydF9wcmVmaXhfcG9wKCk7CisJfSBlbHNlIGlmICghc3RyY21wKGFy
Z3ZbMV0sICJpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uLXRjZyIpKSB7CisJCXVuZGVy
X3RjZyA9IHRydWU7CisJCXJlcG9ydF9wcmVmaXhfcHVzaChhcmd2WzFdKTsKKwkJdGVzdF9taWdy
YXRlX3VubWFwcGVkX2NvbGxlY3Rpb24oKTsKKwkJcmVwb3J0X3ByZWZpeF9wb3AoKTsKIAl9IGVs
c2UgaWYgKHN0cmNtcChhcmd2WzFdLCAiaXRzLWludHJvc3BlY3Rpb24iKSA9PSAwKSB7CiAJCXJl
cG9ydF9wcmVmaXhfcHVzaChhcmd2WzFdKTsKIAkJdGVzdF9pdHNfaW50cm9zcGVjdGlvbigpOwpk
aWZmIC0tZ2l0IGEvYXJtL3VuaXR0ZXN0cy5jZmcgYi9hcm0vdW5pdHRlc3RzLmNmZwppbmRleCAx
YTM5NDI4Li5hZGMxYmJmIDEwMDY0NAotLS0gYS9hcm0vdW5pdHRlc3RzLmNmZworKysgYi9hcm0v
dW5pdHRlc3RzLmNmZwpAQCAtMjA1LDcgKzIwNSw3IEBAIGV4dHJhX3BhcmFtcyA9IC1tYWNoaW5l
IGdpYy12ZXJzaW9uPTMgLWFwcGVuZCAnaXRzLXBlbmRpbmctbWlncmF0aW9uJwogZ3JvdXBzID0g
aXRzIG1pZ3JhdGlvbgogYXJjaCA9IGFybTY0CiAKLVtpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xs
ZWN0aW9uXQorW2l0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24ta3ZtXQogZmlsZSA9IGdp
Yy5mbGF0CiBzbXAgPSAkTUFYX1NNUAogYWNjZWwgPSBrdm0KQEAgLTIxMyw2ICsyMTMsMTQgQEAg
ZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZlcnNpb249MyAtYXBwZW5kICdpdHMtbWlncmF0
ZS11bm1hcHBlZC1jb2xsZWN0aW9uJwogZ3JvdXBzID0gaXRzIG1pZ3JhdGlvbgogYXJjaCA9IGFy
bTY0CiAKK1tpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uLXRjZ10KK2ZpbGUgPSBnaWMu
ZmxhdAorc21wID0gJE1BWF9TTVAKK2FjY2VsID0gdGNnCitleHRyYV9wYXJhbXMgPSAtbWFjaGlu
ZSBnaWMtdmVyc2lvbj0zIC1hcHBlbmQgJ2l0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24t
dGNnJworZ3JvdXBzID0gaXRzIG1pZ3JhdGlvbgorYXJjaCA9IGFybTY0CisKICMgVGVzdCBQU0NJ
IGVtdWxhdGlvbgogW3BzY2ldCiBmaWxlID0gcHNjaS5mbGF0Ci0tIAoyLjIwLjEKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

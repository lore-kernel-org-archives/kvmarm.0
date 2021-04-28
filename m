Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4260C43461
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BC156142C
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BC156142C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDA184B234;
	Wed, 28 Apr 2021 06:18:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V+PDoBsToVD3; Wed, 28 Apr 2021 06:18:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E2064B245;
	Wed, 28 Apr 2021 06:18:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E1494B22E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7O5NAAerZBrh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 06:18:52 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB1424B236
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:51 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id h15so10178019wre.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 03:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=oZnOV6h4qE9XN8eV45ogIXJuOiGbasz5bo3bp014tJU=;
 b=ANukVHXncbLdbgHdhFWXicL6oAdfFtCcf2YirwriVA4no99pPgstEO2RBPIjibx6g8
 nlffMe5pHxW6pOhzQoEmoo/n+D4hKxlvyGOY7k+NC3PlSWu5Jb4CY8BANgzKFMZqavfU
 roWKWKJGmaCbeAun1KO/Luh2ACBlD7nxDsp0vFvUeCj+iDoPZir35+uMZzC1Cp2sr4Lu
 VVN0vSbiol6mSi5ECjnJjcXI4+hSUIkgBUI6ay7IUnvinESDf1WTMc8u1938koOC85Gy
 x99mUjPVIg6Xste2niTYJqDR5SNkeOpLFtOE6U8z8c8zJuW1KL7geU/8NzMdg+WB77n8
 gLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=oZnOV6h4qE9XN8eV45ogIXJuOiGbasz5bo3bp014tJU=;
 b=fSwF3kKwridUZ0IuA/xX5+iHpxPiTPu+h1kzVhVzI5nnrDH1ov2ejqzCJdrAncavvF
 F8Dv0kR25Cb4LY2ywXs/1Guf5w9Go5S2F1aCjQfegB7gDn9e/Jclv1w9Qqcb8ePP1Yms
 AzuHw+B4urzdTeBoMxfDzTbc5QldEgORHfYPc7neaN/QQo9PY26R6BIId5FJDSdoofXx
 w6QlwbhirCT2cm1mjREA2mi5Nb2WZ9PHhLHnQVAnaGgMVf7i0fWxMARi8ZVOo71p5+1Y
 2szla556CAt+TykZkRiaVOpwHvW092q0smH6WRDb6Kf+15BWK+2Y39hT3utEbSpohiKf
 3ewg==
X-Gm-Message-State: AOAM531A5pJ91QBCL3t2ZuE1j9tyjnY6gwfiAZUo6PZNnMRCMCspaX7f
 V8V6zk3kh+wANsvoCdvrxI59sw==
X-Google-Smtp-Source: ABdhPJx4lXogaQ0G+Fi1V4EswMRVo+Z1RplrLBVXheFEI7EdeYbid5vv/TMhgbDmRt2wHswrTJ4YPg==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr2611724wrm.32.1619605131119; 
 Wed, 28 Apr 2021 03:18:51 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id u2sm5734412wmc.22.2021.04.28.03.18.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 4D0661FF90;
 Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Date: Wed, 28 Apr 2021 11:18:44 +0100
Message-Id: <20210428101844.22656-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
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
IHRvdGFsbHkgbmV3IHRlc3QgbmFtZQppbnN0ZWFkIG9mIGFkanVzdGluZyB0aGUgYXBwZW5kIGFz
IHdlIGhhdmUgYmVmb3JlPyBXZWxsIHRoZQpydW5fbWlncmF0aW9uIHNoZWxsIHNjcmlwdCB1c2Vz
IGV2YWwgIiRAIiB3aGljaCB1bndyYXBzIHRoZSAtYXBwZW5kCmxlYWRpbmcgdG8gYW55IHNlY29u
ZCBwYXJhbWV0ZXIgYmVpbmcgc3BsaXQgYW5kIGxlYXZpbmcgUUVNVSB2ZXJ5CmNvbmZ1c2VkIGFu
ZCB0aGUgdGVzdCBoYW5naW5nLiBUaGlzIHNlZW1lZCBzaW1wbGVyIHRoYW4gcmUtd3JpdGluZyBh
bGwKdGhlIHRlc3QgcnVubmluZyBsb2dpYyBpbiBzb21ldGhpbmcgc2FuZSA7LSkKClNpZ25lZC1v
ZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KQ2M6IFNoYXNoaSBN
YWxsZWxhIDxzaGFzaGkubWFsbGVsYUBsaW5hcm8ub3JnPgotLS0KIGFybS9naWMuYyAgICAgICAg
IHwgIDcgKysrKysrLQogYXJtL3VuaXR0ZXN0cy5jZmcgfCAxMSArKysrKysrKysrLQogMiBmaWxl
cyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2FybS9naWMuYyBiL2FybS9naWMuYwppbmRleCA5NmEzMjlkLi4zYmM3NDc3IDEwMDY0NAotLS0g
YS9hcm0vZ2ljLmMKKysrIGIvYXJtL2dpYy5jCkBAIC04NDMsNyArODQzLDcgQEAgc3RhdGljIHZv
aWQgdGVzdF9taWdyYXRlX3VubWFwcGVkX2NvbGxlY3Rpb24odm9pZCkKIAkJZ290byBkb19taWdy
YXRlOwogCX0KIAotCWlmICghZXJyYXRhKEVSUkFUQV9VTk1BUFBFRF9DT0xMRUNUSU9OUykpIHsK
KwlpZiAoIWVycmF0YShFUlJBVEFfVU5NQVBQRURfQ09MTEVDVElPTlMpICYmICF1bmRlcl90Y2cp
IHsKIAkJcmVwb3J0X3NraXAoIlNraXBwaW5nIHRlc3QsIGFzIHRoaXMgdGVzdCBoYW5ncyB3aXRo
b3V0IHRoZSBmaXguICIKIAkJCSAgICAiU2V0ICVzPXkgdG8gZW5hYmxlLiIsIEVSUkFUQV9VTk1B
UFBFRF9DT0xMRUNUSU9OUyk7CiAJCXRlc3Rfc2tpcHBlZCA9IHRydWU7CkBAIC0xMDE3LDYgKzEw
MTcsMTEgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCQlyZXBvcnRfcHJlZml4
X3B1c2goYXJndlsxXSk7CiAJCXRlc3RfbWlncmF0ZV91bm1hcHBlZF9jb2xsZWN0aW9uKCk7CiAJ
CXJlcG9ydF9wcmVmaXhfcG9wKCk7CisJfSBlbHNlIGlmICghc3RyY21wKGFyZ3ZbMV0sICJpdHMt
bWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uLXRjZyIpKSB7CisJCXVuZGVyX3RjZyA9IHRydWU7
CisJCXJlcG9ydF9wcmVmaXhfcHVzaChhcmd2WzFdKTsKKwkJdGVzdF9taWdyYXRlX3VubWFwcGVk
X2NvbGxlY3Rpb24oKTsKKwkJcmVwb3J0X3ByZWZpeF9wb3AoKTsKIAl9IGVsc2UgaWYgKHN0cmNt
cChhcmd2WzFdLCAiaXRzLWludHJvc3BlY3Rpb24iKSA9PSAwKSB7CiAJCXJlcG9ydF9wcmVmaXhf
cHVzaChhcmd2WzFdKTsKIAkJdGVzdF9pdHNfaW50cm9zcGVjdGlvbigpOwpkaWZmIC0tZ2l0IGEv
YXJtL3VuaXR0ZXN0cy5jZmcgYi9hcm0vdW5pdHRlc3RzLmNmZwppbmRleCBkNGRiYzhiLi5lOGYy
ZTc0IDEwMDY0NAotLS0gYS9hcm0vdW5pdHRlc3RzLmNmZworKysgYi9hcm0vdW5pdHRlc3RzLmNm
ZwpAQCAtMjE0LDEzICsyMTQsMjIgQEAgZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZlcnNp
b249MyAtYXBwZW5kICdpdHMtcGVuZGluZy1taWdyYXRpb24nCiBncm91cHMgPSBpdHMgbWlncmF0
aW9uCiBhcmNoID0gYXJtNjQKIAotW2l0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb25dCitb
aXRzLW1pZ3JhdGUtdW5tYXBwZWQtY29sbGVjdGlvbi1rdm1dCiBmaWxlID0gZ2ljLmZsYXQKIHNt
cCA9ICRNQVhfU01QCithY2NlbCA9IGt2bQogZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZl
cnNpb249MyAtYXBwZW5kICdpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uJwogZ3JvdXBz
ID0gaXRzIG1pZ3JhdGlvbgogYXJjaCA9IGFybTY0CiAKK1tpdHMtbWlncmF0ZS11bm1hcHBlZC1j
b2xsZWN0aW9uLXRjZ10KK2ZpbGUgPSBnaWMuZmxhdAorc21wID0gJE1BWF9TTVAKK2FjY2VsID0g
dGNnCitleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMtdmVyc2lvbj0zIC1hcHBlbmQgJ2l0cy1t
aWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24tdGNnJworZ3JvdXBzID0gaXRzIG1pZ3JhdGlvbgor
YXJjaCA9IGFybTY0CisKICMgVGVzdCBQU0NJIGVtdWxhdGlvbgogW3BzY2ldCiBmaWxlID0gcHNj
aS5mbGF0Ci0tIAoyLjIwLjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

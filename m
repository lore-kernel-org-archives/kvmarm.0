Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC2EC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:46:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D649861B1E
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:46:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D649861B1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B2D34B1F4;
	Thu, 18 Nov 2021 13:46:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qx0qBAGU9yh3; Thu, 18 Nov 2021 13:46:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD9A4B1E6;
	Thu, 18 Nov 2021 13:46:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA914B1E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3TX+cc-DzZrR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:46:53 -0500 (EST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA8644B183
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:46:52 -0500 (EST)
Received: by mail-wr1-f51.google.com with SMTP id n29so13392146wra.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=XS343c0IO3niqftwP4v6K7OUkGkeIMiA5I+9ZdZYBh0=;
 b=zjCZRzmU5VCoORz9MR7qg3iHeYGB+ARqpBgEFkojvl3nOwIzmuTPU5pdKUpWT8la3D
 UGY2TfUGFT4IEnWlBAxDQbMkUvtFSzNFeJogW9rLHEt6T2HeHxTkT2xjszrOKBdtUFb9
 HDYwnutRjR2KmtByWx8sGIFQ9tOlC16XfCsOjBG34gpIOtSvCfOaLbsfTOkaX+bQWFhq
 oOgZPpjmyct9bW6VdtSvsKyWBNv6blWpTi+XmkhSew3RZDofHkbxCG/imoO5BTFK/4fA
 3w7GEk/JPKDNoNsdN20Tm53RgVUyMk9bcZUxmPoeqoX1f3rybUdDDJYupwV2fRG6wp+b
 73Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=XS343c0IO3niqftwP4v6K7OUkGkeIMiA5I+9ZdZYBh0=;
 b=C1vGCxMNGtqNA9H6Oo6yV2YydUdYtGl1AJVF5d4LGFvYghUkfB1jYRwh6RxlJzu2DG
 GIVbtbZsKgPQZgCLaZpm2q8zj3k9CJ7VuRUOSkV7q0on3BXjTtKuJJklKwegEtPElTe1
 7xxRNiYGewFE0MbaZe0gl5kg2PA71UGGgR93IA9RijkFQPEI2gSSMS7/mVCqBZjt+0nh
 QU2KejZu+iSCRwz7GtJf3r7BHuVgf8e7qTQ+qWkWue8apEienlxD383YpA/W1VXaU+cm
 sIktEfcdN5rm1oRKQw9+yAeq3KXLqRNMWdas6umZM9ULVSTOl4EPOWFth8Xo/avxsFSi
 um8Q==
X-Gm-Message-State: AOAM533rB0PCdbScJ4dP23KfkPHv+8Zj7zgmL9TfXGns3D3HDIg9ba0t
 XV7Z4oh0c/dOwNb7YjjV3hoipg==
X-Google-Smtp-Source: ABdhPJw2NzXqRxesIK9jA2HRDk+2Uk6jmBQZFD0hYkGO36LMi1zQxSDYgNlrw4ejSdORJel1NMHILw==
X-Received: by 2002:adf:f012:: with SMTP id j18mr33404834wro.353.1637261211921; 
 Thu, 18 Nov 2021 10:46:51 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id 8sm9332039wmg.24.2021.11.18.10.46.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:46:50 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 3D38D1FF96;
 Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 00/10] MTTCG sanity tests for ARM
Date: Thu, 18 Nov 2021 18:46:40 +0000
Message-Id: <20211118184650.661575-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Cc: maz@kernel.org, qemu-arm@nongnu.org, idan.horowitz@gmail.com,
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

SGksCgpJdCdzIGJlZW4gYSBsb25nIHRpbWUgc2luY2UgSSBsYXN0IHBvc3RlZCB0aGVzZSBidXQg
SSdkIGxpa2UgdG8KaW5jb3Jwb3JhdGUgc29tZSBNVFRDRyB0ZXN0cyBpbnRvIFFFTVUncyB1cHN0
cmVhbSBhY2NlcHRhbmNlIHRlc3RzIGFuZAphIGZpcnN0IHN0ZXAgaXMgZ2V0dGluZyB0aGVzZSB1
cC1zdHJlYW1lZC4gTW9zdCBvZiB0aGUgY2hhbmdlcyBhcmUKZml4aW5nIHVwIHRoZSBudW1lcm91
cyBjaGVja3BhdGNoIGZhaWx1cmVzIChhbHRob3VnaCBpc2FhYyByZW1haW5zCnVuY2hhbmdlZCBh
bmQgc29tZSB3YXJuaW5ncyBtYWtlIG5vIHNlbnNlIGZvciBrdm0tdW5pdC10ZXN0cykuCgpJIGRy
b3BwZWQgYW4gYWRkaXRpb25hbCB0ZXN0IHdoaWNoIGF0dGVtcHRzIHRvIHRlc3QgZm9yIGRhdGEg
Zmx1c2gKYmVoYXZpb3VyIGJ1dCBpdCBzdGlsbCBuZWVkcyBzb21lIHdvcms6CgogIGh0dHBzOi8v
Z2l0aHViLmNvbS9zdHNxdWFkL2t2bS11bml0LXRlc3RzL2NvbW1pdC83MTJlYjNhMjg3ZGYyNGNk
ZWZmMDBlZjk2NmQ2OGFlZjZmZjJiOGViCgpBbGV4IEJlbm7DqWUgKDEwKToKICBkb2NzOiBtZW50
aW9uIGNoZWNrcGF0Y2ggaW4gdGhlIFJFQURNRQogIGFybS9mbGF0LmxkczogZG9uJ3QgZHJvcCBk
ZWJ1ZyBkdXJpbmcgbGluawogIE1ha2VmaWxlOiBhZGQgR05VIGdsb2JhbCB0YWdzIHN1cHBvcnQK
ICBydW5fdGVzdHMuc2g6IGFkZCAtLWNvbmZpZyBvcHRpb24gZm9yIGFsdCB0ZXN0IHNldAogIGxp
YjogYWRkIGlzYWFjIHBybmcgbGlicmFyeSBmcm9tIENDQU4KICBhcm0vdGxiZmx1c2gtY29kZTog
VExCIGZsdXNoIGR1cmluZyBjb2RlIGV4ZWN1dGlvbgogIGFybS9sb2NraW5nLXRlc3RzOiBhZGQg
Y29tcHJlaGVuc2l2ZSBsb2NraW5nIHRlc3QKICBhcm0vYmFycmllci1saXRtdXMtdGVzdHM6IGFk
ZCBzaW1wbGUgbXAgYW5kIHNhbCBsaXRtdXMgdGVzdHMKICBhcm0vcnVuOiB1c2Ugc2VwYXJhdGUg
LS1hY2NlbCBmb3JtCiAgYXJtL3RjZy10ZXN0OiBzb21lIGJhc2ljIFRDRyBleGVyY2lzaW5nIHRl
c3RzCgogYXJtL3J1biAgICAgICAgICAgICAgICAgICB8ICAgNCArLQogcnVuX3Rlc3RzLnNoICAg
ICAgICAgICAgICB8ICAxMSArLQogTWFrZWZpbGUgICAgICAgICAgICAgICAgICB8ICAgNSArLQog
YXJtL01ha2VmaWxlLmFybSAgICAgICAgICB8ICAgMiArCiBhcm0vTWFrZWZpbGUuYXJtNjQgICAg
ICAgIHwgICAyICsKIGFybS9NYWtlZmlsZS5jb21tb24gICAgICAgfCAgIDYgKy0KIGxpYi9hcm0v
YXNtL2JhcnJpZXIuaCAgICAgfCAgNjEgKysrKysrCiBsaWIvYXJtNjQvYXNtL2JhcnJpZXIuaCAg
IHwgIDUwICsrKysrCiBsaWIvcHJuZy5oICAgICAgICAgICAgICAgIHwgIDgyICsrKysrKysKIGxp
Yi9wcm5nLmMgICAgICAgICAgICAgICAgfCAxNjIgKysrKysrKysrKysrKysKIGFybS9mbGF0Lmxk
cyAgICAgICAgICAgICAgfCAgIDEgLQogYXJtL3RjZy10ZXN0LWFzbS5TICAgICAgICB8IDE3MSAr
KysrKysrKysrKysrKysKIGFybS90Y2ctdGVzdC1hc202NC5TICAgICAgfCAxNzAgKysrKysrKysr
KysrKysKIGFybS9iYXJyaWVyLWxpdG11cy10ZXN0LmMgfCA0NTAgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysKIGFybS9sb2NraW5nLXRlc3QuYyAgICAgICAgfCAzMjIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrCiBhcm0vc3BpbmxvY2stdGVzdC5jICAgICAgIHwgIDg3
IC0tLS0tLS0tCiBhcm0vdGNnLXRlc3QuYyAgICAgICAgICAgIHwgMzM4ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIGFybS90bGJmbHVzaC1jb2RlLmMgICAgICAgfCAyMDkgKysrKysrKysr
KysrKysrKysrCiBhcm0vbXR0Y2d0ZXN0cy5jZmcgICAgICAgIHwgMTc2ICsrKysrKysrKysrKysr
KwogUkVBRE1FLm1kICAgICAgICAgICAgICAgICB8ICAgMiArCiAyMCBmaWxlcyBjaGFuZ2VkLCAy
MjE2IGluc2VydGlvbnMoKyksIDk1IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGxp
Yi9wcm5nLmgKIGNyZWF0ZSBtb2RlIDEwMDY0NCBsaWIvcHJuZy5jCiBjcmVhdGUgbW9kZSAxMDA2
NDQgYXJtL3RjZy10ZXN0LWFzbS5TCiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJtL3RjZy10ZXN0LWFz
bTY0LlMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcm0vYmFycmllci1saXRtdXMtdGVzdC5jCiBjcmVh
dGUgbW9kZSAxMDA2NDQgYXJtL2xvY2tpbmctdGVzdC5jCiBkZWxldGUgbW9kZSAxMDA2NDQgYXJt
L3NwaW5sb2NrLXRlc3QuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGFybS90Y2ctdGVzdC5jCiBjcmVh
dGUgbW9kZSAxMDA2NDQgYXJtL3RsYmZsdXNoLWNvZGUuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGFy
bS9tdHRjZ3Rlc3RzLmNmZwoKLS0gCjIuMzAuMgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==

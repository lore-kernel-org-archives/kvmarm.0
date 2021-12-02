Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B0CC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 11:54:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31AF14B1E4;
	Thu,  2 Dec 2021 06:54:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ltQvKp7ay69; Thu,  2 Dec 2021 06:54:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC6A4B175;
	Thu,  2 Dec 2021 06:54:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC37A4B156
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:54:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SGqir+bUBigC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 06:53:55 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C5604B08F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 06:53:55 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id a9so59099968wrr.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 03:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=assPRJZISp/N09x/XwLMYXECdxd+01DO7D0xsbG5ltw=;
 b=KOJZVynTFuG/6NOJXr2C4Vazs7n8HHWiJb78KKi6YLrt5Wi9b+schevcHXrG1rf73V
 RuHhI8pWw6nXqzZhTefRIjJSu5dcW/GT8BvyQhviuQHchvtniR+E9QqSQuYmy6RTYgPI
 lnNAb9VcYKBMBun9WuGm0pA8+rovBl0E5QL7CF3y68JGjie/63fYnCv/QcNJn1dma8aK
 BWvxRtwONYGuByLqp9txeW7NEJk4y32/6yFSPlQd6GefkczXizFNh0R4DaHPJQBx1XlH
 x5jBVrONLOn6RzTTlPvajcFVK/nw+ORyhx5S+QLv91Y6xfmYcoEc5kiWGXlPt3eq7S35
 k4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=assPRJZISp/N09x/XwLMYXECdxd+01DO7D0xsbG5ltw=;
 b=b3Og+/IJbYoEnIax1BjZOLjE+M0z6EdUP5Wcq5itqju3VD53rrHCFaciP6gqHH47/g
 g5yTuH0+v4uDHZoKhNJMopSdj2sSIF6KPWbOnPIcHCqsTq5vtOpTVQaYA1lzw+5WtZOs
 dRmz9+qVne80ZegnK9d97lBha+AkAVBkuS/v6IsjoKBDrvFMHGxI/sp/HPwvPp/DbTsv
 hg/lFVaLt75xhxu8ROGoxPBcqAAUbQ+nGWhRkT000gGVCNf6iuqQjZiOoWukHWigYGCE
 vcXwhJxRP/NOZZWjNBihLXv3GMdtAj3nGrAsSfRGjh/nqckqZITgbbze/rrDHuo79fvC
 jRfg==
X-Gm-Message-State: AOAM531wQT1GuIjtBYDb5j9FUMkU7FAB8i6aAXWTCRMyxk3XHzd314lR
 Jr0qgO9EKMOFZThbA3S2dHuW2Q==
X-Google-Smtp-Source: ABdhPJwwW+FHTijTO4l+Zd2NHkZo+99Xp3nRtXN0H2oqzfplC6cix6takcu1+C2dOWtuBhiGvbvR4g==
X-Received: by 2002:adf:97c2:: with SMTP id t2mr14007936wrb.577.1638446034298; 
 Thu, 02 Dec 2021 03:53:54 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id f15sm2448073wmg.30.2021.12.02.03.53.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Dec 2021 03:53:53 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 72A0C1FF96;
 Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: pbonzini@redhat.com,
	drjones@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Date: Thu,  2 Dec 2021 11:53:43 +0000
Message-Id: <20211202115352.951548-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, christoffer.dall@arm.com,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

SGksCgpOb3QgYSBncmVhdCBkZWFsIGhhcyBjaGFuZ2VkIGZyb20gdGhlIGxhc3QgcG9zdGluZyBh
bHRob3VnaCBJIGhhdmUKZHJvcHBlZCB0aGUgYWRkaXRpb25hbCB1bml0dGVzdHMuY2ZnIGluIGZh
dm91ciBvZiBzZXR0aW5nICJub2RlZmF1bHQiCmZvciB0aGUgdGVzdHMuIE90aGVyd2lzZSB0aGUg
Y2xlYW4tdXBzIGFyZSBtYWlubHkgdGV4dHVhbCAocmVtb3ZpbmcKcHJpbnRmcywgcmFuZG9tIG5l
d2xpbmVzIGFuZCBjbGVhbmluZyB1cCBjb21tZW50cykuIEFzIHVzdWFsIHRoZQpkZXRhaWxzIGFy
ZSBpbiB0aGUgY29tbWl0cyBiZWxsb3cgdGhlIC0tLS4KCkkndmUgYWxzbyB0d2Vha2VkIC5naXQv
Y29uZmlnIHNvIGdldF9tYWludGFpbmVyLnBsIHNob3VsZCBlbnN1cmUKZGlyZWN0IGRlbGl2ZXJ5
IG9mIHRoZSBwYXRjaGVzIDstKQoKQWxleCBCZW5uw6llICg5KToKICBkb2NzOiBtZW50aW9uIGNo
ZWNrcGF0Y2ggaW4gdGhlIFJFQURNRQogIGFybS9mbGF0LmxkczogZG9uJ3QgZHJvcCBkZWJ1ZyBk
dXJpbmcgbGluawogIE1ha2VmaWxlOiBhZGQgR05VIGdsb2JhbCB0YWdzIHN1cHBvcnQKICBsaWI6
IGFkZCBpc2FhYyBwcm5nIGxpYnJhcnkgZnJvbSBDQ0FOCiAgYXJtL3RsYmZsdXNoLWNvZGU6IFRM
QiBmbHVzaCBkdXJpbmcgY29kZSBleGVjdXRpb24KICBhcm0vbG9ja2luZy10ZXN0czogYWRkIGNv
bXByZWhlbnNpdmUgbG9ja2luZyB0ZXN0CiAgYXJtL2JhcnJpZXItbGl0bXVzLXRlc3RzOiBhZGQg
c2ltcGxlIG1wIGFuZCBzYWwgbGl0bXVzIHRlc3RzCiAgYXJtL3J1bjogdXNlIHNlcGFyYXRlIC0t
YWNjZWwgZm9ybQogIGFybS90Y2ctdGVzdDogc29tZSBiYXNpYyBUQ0cgZXhlcmNpc2luZyB0ZXN0
cwoKIGFybS9ydW4gICAgICAgICAgICAgICAgICAgfCAgIDQgKy0KIE1ha2VmaWxlICAgICAgICAg
ICAgICAgICAgfCAgIDUgKy0KIGFybS9NYWtlZmlsZS5hcm0gICAgICAgICAgfCAgIDIgKwogYXJt
L01ha2VmaWxlLmFybTY0ICAgICAgICB8ICAgMiArCiBhcm0vTWFrZWZpbGUuY29tbW9uICAgICAg
IHwgICA2ICstCiBsaWIvYXJtL2FzbS9iYXJyaWVyLmggICAgIHwgIDE5ICsrCiBsaWIvYXJtNjQv
YXNtL2JhcnJpZXIuaCAgIHwgIDUwICsrKysrCiBsaWIvcHJuZy5oICAgICAgICAgICAgICAgIHwg
IDgyICsrKysrKysKIGxpYi9wcm5nLmMgICAgICAgICAgICAgICAgfCAxNjIgKysrKysrKysrKysr
KysKIGFybS9mbGF0LmxkcyAgICAgICAgICAgICAgfCAgIDEgLQogYXJtL3RjZy10ZXN0LWFzbS5T
ICAgICAgICB8IDE3MSArKysrKysrKysrKysrKysKIGFybS90Y2ctdGVzdC1hc202NC5TICAgICAg
fCAxNzAgKysrKysrKysrKysrKysKIGFybS9iYXJyaWVyLWxpdG11cy10ZXN0LmMgfCA0NTAgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGFybS9sb2NraW5nLXRlc3QuYyAg
ICAgICAgfCAzMjIgKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBhcm0vc3BpbmxvY2stdGVz
dC5jICAgICAgIHwgIDg3IC0tLS0tLS0tCiBhcm0vdGNnLXRlc3QuYyAgICAgICAgICAgIHwgMzM4
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGFybS90bGJmbHVzaC1jb2RlLmMgICAgICAg
fCAyMDkgKysrKysrKysrKysrKysrKysrCiBhcm0vdW5pdHRlc3RzLmNmZyAgICAgICAgIHwgMTcw
ICsrKysrKysrKysrKysrCiBSRUFETUUubWQgICAgICAgICAgICAgICAgIHwgICAzICsKIDE5IGZp
bGVzIGNoYW5nZWQsIDIxNjEgaW5zZXJ0aW9ucygrKSwgOTIgZGVsZXRpb25zKC0pCiBjcmVhdGUg
bW9kZSAxMDA2NDQgbGliL3BybmcuaAogY3JlYXRlIG1vZGUgMTAwNjQ0IGxpYi9wcm5nLmMKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBhcm0vdGNnLXRlc3QtYXNtLlMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBh
cm0vdGNnLXRlc3QtYXNtNjQuUwogY3JlYXRlIG1vZGUgMTAwNjQ0IGFybS9iYXJyaWVyLWxpdG11
cy10ZXN0LmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcm0vbG9ja2luZy10ZXN0LmMKIGRlbGV0ZSBt
b2RlIDEwMDY0NCBhcm0vc3BpbmxvY2stdGVzdC5jCiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJtL3Rj
Zy10ZXN0LmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcm0vdGxiZmx1c2gtY29kZS5jCgotLSAKMi4z
MC4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD00C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 14:43:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D52B4B236;
	Mon,  7 Mar 2022 09:43:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 25o9P11HzREA; Mon,  7 Mar 2022 09:43:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6104B108;
	Mon,  7 Mar 2022 09:43:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0767149B08
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 09:43:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lt+CGX--XzKg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 09:43:08 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E96CB40D0B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 09:43:07 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 a16-20020adff7d0000000b001f0473a6b25so4342441wrq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 06:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc
 :content-transfer-encoding;
 bh=tMeXsZqDb75ACGRy/sIWlewY6GCrVT1yFLrhXMTRT7w=;
 b=p0BnNyp2RCikZ7LWvPb49qd3X9/0vxwZAXMMyLUCVHQBcwSIyzmnb422xQuAXfHN97
 E3Kxw9Z4nU8qdPr4udJGiR9I4o+dxtzGy+O6PZruMBjCIG57vDtC+yz6oTwgTqkxhp1p
 lNJPoLKHoJ+AeP4qeaUI8xlpcuKC+p1aRFHw9GuEqxpSVpnvs3d9l0Z2aNR5HrhccQR+
 JNRr+OglCzjnK32/Up4jbu6DzOwegGAR8rFc2CpRwm1zu+kbiczSYegCebzhvhLk2BS3
 uLyVtPG1c7b9Yi84uHg+xs1GSL5j1B/JPy48ezS8g3ry1IzXRELRkK/+iC+aGqAukpb2
 4I6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
 :content-transfer-encoding;
 bh=tMeXsZqDb75ACGRy/sIWlewY6GCrVT1yFLrhXMTRT7w=;
 b=Y3H2ZAw/IdSJp67lz/la0iIZ8BQvjThhYGTvsXICb6eRAS1IVjx0pLP90hGyO4ulJG
 dRJnOUIuL+MMfTqt4KUeSmxBZsDOVZS6cQUsLO1tFwRuZP5v+cPOvQ58SWrHnBDnX2jj
 zaSiLyqtQlz7U8WLkg3sJ2doFJbrAL+SkyqCFWrQoPktQ6eh61OcOVoQttm2Qc+RiqZA
 vBviMpY7qFb10Y3YBa575/KZYShpyueNYe82mGCsWu/b2d3fDA6IAbexj1edGbqjWzT4
 G7sQXIZfTd/7YYZYmmuyBIMtng9g13e/US/GF/rQb+eQNyKKrDBkp38909+pGGdx73eW
 BsFw==
X-Gm-Message-State: AOAM5331RjLbHmmJLKdSSjRpOUx4q/VfhMUd9i3XiQofvS5dbjmy4f22
 1TTWa1Nu0aiy2w+nh4SN4PfK77Ia/mm93rpOCyw=
X-Google-Smtp-Source: ABdhPJz3h7ACGFY05PU/VbgMi3gxENh8oNI1n1Bl2UxsVd5ehg0ma82ciZIHJK6iNc1Gq1U3oqDMBBrFNEG0xldLIyE=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:adf:a445:0:b0:1f0:3271:d612 with SMTP
 id e5-20020adfa445000000b001f03271d612mr8432829wra.325.1646664186892; Mon, 07
 Mar 2022 06:43:06 -0800 (PST)
Date: Mon,  7 Mar 2022 14:42:41 +0000
Message-Id: <20220307144243.2039409-1-sebastianene@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v8 0/3] aarch64: Add stolen time support
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

VGhlc2UgcGF0Y2hlcyBhZGQgc3VwcG9ydCBmb3Igc3RvbGVuIHRpbWUgZnVuY3Rpb25hbGl0eS4K
ClBhdGNoICMxIG1vdmVzIHRoZSB2Q1BVIHN0cnVjdHVyZSBpbml0aWFsaXNhdGlvbiBiZWZvcmUg
dGhlIHRhcmdldC0+aW5pdCgpCmNhbGwgdG8gYWxsb3cgZWFybHkgYWNjZXNzIHRvIHRoZSBrdm0g
c3RydWN0dXJlIGZyb20gdGhlIHZDUFUKZHVyaW5nIHRhcmdldC0+aW5pdCgpLgoKUGF0Y2ggIzIg
bW9kaWZpZXMgdGhlIG1lbW9yeSBsYXlvdXQgaW4gYXJtLWNvbW1vbi9rdm0tYXJjaC5oIGFuZCBh
ZGRzIGEKbmV3IE1NSU8gZGV2aWNlIFBWVElNRSBhZnRlciB0aGUgUlRDIHJlZ2lvbi4gQSBuZXcg
ZmxhZyBpcyBhZGRlZCBpbgprdm0tY29uZmlnLmggdGhhdCB3aWxsIGJlIHVzZWQgdG8gY29udHJv
bCBbZW5hYmxlL2Rpc2FibGVdIHRoZSBwdnRpbWUKZnVuY3Rpb25hbGl0eS4gU3RvbGVuIHRpbWUg
aXMgZW5hYmxlZCBieSBkZWZhdWx0IHdoZW4gdGhlIGhvc3QKc3VwcG9ydHMgS1ZNX0NBUF9TVEVB
TF9USU1FLgoKUGF0Y2ggIzMgYWRkcyBhIG5ldyBjb21tYW5kIGxpbmUgYXJndW1lbnQgdG8gZGlz
YWJsZSB0aGUgc3RvbGVuIHRpbWUKZnVuY3Rpb25hbGl0eShieSBkZWZhdWx0IGlzIGVuYWJsZWQp
LgoKQ2hhbmdlbG9nIHNpbmNlIHY3OgogLSBwYXRjaCAjMjoKICAgLSBtb3ZlIHRlYXJkb3duIHRv
IGt2bV9jcHVfX2RlbGV0ZSgpCiAgIC0gZG9u4oCZdCBjYWxsIGt2bV9fc3VwcG9ydHNfZXh0ZW5z
aW9uIGZvciB0aGUgcmVtYWluaWcgY3B14oCZcyBpZiBpdCBmYWlsZWQKICAgICBvbmNlIGFuZCBm
b3JjZSAnbm9fcHZ0aW1lJyB0byAxCiAgIC0gcmVwbGFjZSB2YXJpYWJsZSBuYW1lICdpc19zdXBw
b3J0ZWQnIHdpdGggJ2lzX2ZhaWxlZF9jZmcnCgpTZWJhc3RpYW4gRW5lICgzKToKICBhYXJjaDY0
OiBQb3B1bGF0ZSB0aGUgdkNQVSBzdHJ1Y3QgYmVmb3JlIHRhcmdldC0+aW5pdCgpCiAgYWFyY2g2
NDogQWRkIHN0b2xlbiB0aW1lIHN1cHBvcnQKICBBZGQgLS1uby1wdnRpbWUgY29tbWFuZCBsaW5l
IGFyZ3VtZW50CgogTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEg
KwogYXJtL2FhcmNoNjQvYXJtLWNwdS5jICAgICAgICAgICAgICAgICAgfCAgIDIgKy0KIGFybS9h
YXJjaDY0L2luY2x1ZGUva3ZtL2t2bS1jcHUtYXJjaC5oIHwgICAyICsKIGFybS9hYXJjaDY0L3B2
dGltZS5jICAgICAgICAgICAgICAgICAgIHwgMTA4ICsrKysrKysrKysrKysrKysrKysrKysrKysK
IGFybS9pbmNsdWRlL2FybS1jb21tb24va3ZtLWFyY2guaCAgICAgIHwgICA2ICstCiBhcm0va3Zt
LWNwdS5jICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxNSArKy0tCiBidWlsdGluLXJ1bi5j
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArCiBpbmNsdWRlL2t2bS9rdm0tY29uZmln
LmggICAgICAgICAgICAgICB8ICAgMSArCiA4IGZpbGVzIGNoYW5nZWQsIDEyOCBpbnNlcnRpb25z
KCspLCA5IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGFybS9hYXJjaDY0L3B2dGlt
ZS5jCgotLSAKMi4zNS4xLjYxNi5nMGJkY2JiNDQ2NC1nb29nCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K

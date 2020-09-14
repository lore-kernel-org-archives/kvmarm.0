Return-Path: <SRS0=WazV=CX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793FEC433E2
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CCB3A21D1B
	for <kvmarm@archiver.kernel.org>; Mon, 14 Sep 2020 17:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gFAAaw1W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCB3A21D1B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4D4B4B58B;
	Mon, 14 Sep 2020 13:28:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O9yChMEMtktP; Mon, 14 Sep 2020 13:28:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6364B571;
	Mon, 14 Sep 2020 13:28:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B09954B567
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JNiSgkpIqJQ0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2020 13:28:01 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87C564B530
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 13:28:01 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id o5so446953wrn.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2020 10:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=AMQigiH2Yj3ljq0v4heVqWDyhdHIO/cGF9bhez3idR8=;
 b=gFAAaw1WaHNJJkqhAadqzBiA1dZjRClqlrPYUxSrgjylyL+3O51yk1GUMxuzgbcrL7
 UEXnOZ6SdaSQxqxdU5Gq/nOZDOBeyC45agRXAq6IQ9/C4Tq+2TWntn6rm/qWMNDLveP4
 ZBJNjXyqs9lt+JXuwoW0N7CsbD5E99Gk5vtG0SBxM74gwDVFDOzs7qQR0QrG0C9MwMJ0
 FvsbbMR6C8V8MoYSzEnE/1EoWvwV3+Qq0uE2kNxc0iB9ue2MKanbboImKXB+wypoSxUM
 flPyEk3CVB7Sq5yN7O0yFqpAxUNJwkoYNuXgF4KpEqkizPNprU86jvEUHwiJbZy8c6i5
 801w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=AMQigiH2Yj3ljq0v4heVqWDyhdHIO/cGF9bhez3idR8=;
 b=P71HzBjK/+Gv27SuxPG9rTZKcl6bhjqpZ2MOlOy1iveVju7m87Nqn6Qq/9Unkbt1ug
 btJ/ZaUXk0iSjj6gzou08Q6YH10TURs+kEw/ojLi2/xuBqZR0w/3595pYuJy41CfIfGC
 ZIzhUM18ftKz4Xf+zwwLEY+y1sD8bSm+abDzOeKgLLlJiaMVZ8NJeLfzGdFsi6JyrTSs
 x39f6wUZJirx8UOy59v22ZtjE/+fes/qb3RrQNi3CyHspLezgyKXznyezZGNsnUioLmg
 ZRQL2WNR8lOtkKr/GcTPDVZqNOaer+4TSJ1/oBivZgAimuoaX3QmDG5tdlM57m4Dzfod
 qXXw==
X-Gm-Message-State: AOAM530fD1vrL/jrtOIM7TBFUNRXaiVh0My07yU11EsNlL41Rf+3qFul
 shCoC2opHZfqSmij2iBb8Rza8g==
X-Google-Smtp-Source: ABdhPJyGmq1oNLTCt+QLZhrFtOEe0CSecXyWrLoDzrYdiMgpu22TCnydQl8WOCfVUWECPgwrH56Q2g==
X-Received: by 2002:a5d:680b:: with SMTP id w11mr18141747wru.73.1600104480318; 
 Mon, 14 Sep 2020 10:28:00 -0700 (PDT)
Received: from localhost (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id h186sm20919367wmf.24.2020.09.14.10.27.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Sep 2020 10:27:59 -0700 (PDT)
From: George-Aurelian Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: [PATCH 00/14] UBSan Enablement for hyp/nVHE code
Date: Mon, 14 Sep 2020 17:27:36 +0000
Message-Id: <20200914172750.852684-1-georgepope@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
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

VGhlIG1haW4gcHJvYmxlbSBzb2x2ZWQgaXMgbG9nZ2luZyBmcm9tIGh5cC9uVkhFLiBCZWNhdXNl
IHRoZSBuVkhFIGNvZGUgaXMKaW5kZXBlbmRlbnQgZnJvbSB0aGUgTGludXgga2VybmVsIHRoZSBs
b2dnaW5nIG1lY2hhbmlzbXMgYXJlbuKAmXQgd29ya2luZy4KRm9yIHRoaXMgcHVycG9zZSBhIGdl
bmVyaWMga3ZtX2RlYnVnX2J1ZmZlciBpcyBkZXNpZ25lZC4gSXQgaXMgY29tcG9zZWQKZnJvbSBh
IHN0YXRpY2FsbHkgYWxsb2NhdGVkIGFycmF5IGFuZCBhIHdyaXRpbmcgaW5kZXggYW5kIGNvbWVz
IHdpdGggYSBzZXQKb2YgbWFjcm9zIHRvIGZhY2lsaXRhdGUgaXTigJlzIHVzYWdlLiBUbyBhdm9p
ZCBjb25jdXJyZW5jeSBwcm9ibGVtcyBiZXR3ZWVuCmNvcmVzLCB0aGUga3ZtX2RlYnVnX2J1ZmZl
ciBpcyBkZWZpbmVkIHBlcl9jcHUuIFRoZSBidWZmZXIgaXMgY2hlY2tlZCBldmVyeQp0aW1lIHdo
ZW4gdGhlIGNvZGUgcmV0dXJucyBmcm9tIGFuIGh2YyBjYWxsLCBieSBtb2RpZnlpbmcgdGhlIGt2
bV9jYWxsX2h5cAphbmQga3ZtX2NhbGxfaHlwX3JldCBtYWNyb3MuIFRoZSBidWZmZXLigJlzIHdy
aXRpbmcgaW5kZXggaXMgcmVzZXRlZCB0byB6ZXJvCmluc2lkZSBvZiB0aGUgZWwxX3N5bmMgZW50
cnkuCgpTaW5jZSBVQlNhbuKAmXMgaGFuZGxlcnMgYXJlIGxpdmluZyBpbnNpZGUgdGhlIGtlcm5l
bCwgdGhleSBjYW4gbm90IGJlIGNhbGxlZAppbnNpZGUgaHlwL25WSEUuIFRvIGVuYWJsZSBVQlNh
biBuZXcgaGFuZGxlcnMgaGFkIHRvIGJlIGRlZmluZWQgdGhlcmUuIFRvCnN0b3JlIHRoZSBkYXRh
IGZyb20gdGhlIGhhbmRsZXIsIHRoZSBrdm1fdWJzYW5fYnVmZiBpcyBkZWZpbmVkLiBJdCBjYW4g
c3RvcmUKbG9nZ2luZyBkYXRhIGZyb20gdGhlIGhhbmRsZXJzIGluIGEgbmV3IGRlZmluZWQgc3Ry
dWN0IGNhbGxlZCBzdHJ1Y3QKa3ZtX3Vic2FuX2luZm8uIEVhY2ggaGFuZGxlciBoYXMgdG8gZW5j
YXBzdWxhdGUgaXTigJlzIGRhdGEgaW5zaWRlIHRoZSBuZXcKc3RydWN0IGFuZCB3cml0ZSBpdCBp
bnRvIHRoZSBidWZmZXIuIFRoZSBrdm1fZGVidWdfYnVmZmVyLmMgZmlsZSBpcwpyZXNwb25zaWJs
ZSBmb3IgZGVjYXBzdWxhdGluZyB0aGUgZGF0YSBhbmQgY2FsbGluZyB0aGUga2VybmVsIGhhbmRs
ZXJzLgpUbyBjaGVjayBpZiBVQlNhbiB3b3JrcyBjb3JyZWN0bHkgaW5zaWRlIGh5cC9uVkhFIHRo
ZSBsYXN0IHBhdGNoIGNvbWVzCndpdGggYSB0ZXN0IG1lY2hhbmlzbSwgdGhhdCBjYWxscyBVQlNh
biB3aGVuIHRoZSBoeXAgaXMgaW5pdGlhbGl6ZWQuCgoKR2VvcmdlIFBvcGVzY3UgKDE0KToKICBL
Vk06IGFybTY0OiBFbmFibGUgVUJTYW4gaW5zdHJ1bWVudGF0aW9uIGluIG5WSEUgaHlwIGNvZGUK
ICBLVk06IGFybTY0OiBEZWZpbmUgYSBtYWNybyBmb3Igc3RvcmluZyBhIHZhbHVlIGluc2lkZSBh
IHBlcl9jcHUKICAgIHZhcmlhYmxlCiAgS1ZNOiBhcm02NDogQWRkIHN1cHBvcnQgZm9yIGNyZWF0
aW5nIGFuZCBjaGVja2luZyBhIGxvZ2dpbmcgYnVmZmVyCiAgICBpbnNpZGUgaHlwL25WSEUKICBL
Vk06IGFybTY0OiBBZGQgc3VwcG9ydCBmb3IgYnVmZmVyIHVzYWdlCiAgS1ZNOiBhcm02NDogRGVm
aW5lIGEgYnVmZmVyIHRoYXQgY2FuIHBhc3MgVUJTYW4gZGF0YSBmcm9tIGh5cC9uVkhFIHRvCiAg
ICBrZXJuZWwKICBGaXggQ0ZMQUdTIGZvciBVQlNBTl9CT1VORFMgb24gQ2xhbmcKICBLVk06IGFy
bTY0OiBFbmFibGUgVUJTQU5fQk9VTkRTIGZvciB0aGUgYm90aCB0aGUga2VybmVsIGFuZCBoeXAv
blZIRQogIEtWTTogYXJtNjQ6IEVuYWJsZSBVQnNhbiBjaGVjayBmb3IgdW5yZWFjaGFibGUgY29k
ZSBpbnNpZGUgaHlwL25WSEUKICAgIGNvZGUKICBLVk06IGFybTY0OiBFbmFibGUgc2hpZnQgb3V0
IG9mIGJvdW5kcyB1bmRlZmluZWQgYmVoYXZpb3VyIGNoZWNrIGZvcgogICAgaHlwL25WSEUKICBL
Vk06IGFybTY0OiBfX3Vic2FuX2hhbmRsZV9sb2FkX2ludmFsaWRfdmFsdWUgaHlwL25WSEUgaW1w
bGVtZW50YXRpb24uCiAgS1ZNOiBhcm02NDogRGV0ZWN0IHR5cGUgbWlzbWF0Y2ggdW5kZWZpbmVk
IGJlaGF2aW91ciBmcm9tIGh5cC9uVkhFCiAgICBjb2RlCiAgS1ZNOiBhcm02NDogRGV0ZWN0IGFy
aXRobWV0aWMgb3ZlcmZsb3cgaXMgaW5zaWRlIGh5cC9uVkhFLgogIEtWTTogYXJtNjQ6IEVuYWJs
ZSB0aGUgQ09ORklHX1RFU1QgVUJTYW4gZm9yIFBLVk0uCiAgRE8gTk9UIE1FUkdFOiBFbmFibGUg
Y29uZmlncyB0byB0ZXN0IHRoZSBwYXRjaCBzZXJpZXMKCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9hc20uaCAgICAgICAgICB8ICAgOCArKwogYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1f
ZGVidWdfYnVmZmVyLmggfCAgNjEgKysrKysrKysKIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3Zt
X2hvc3QuaCAgICAgICAgIHwgIDEyICsrCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV91YnNh
bi5oICAgICAgICB8ICA1MyArKysrKysrCiBhcmNoL2FybTY0L2t2bS9LY29uZmlnICAgICAgICAg
ICAgICAgICAgICB8ICAgMyArCiBhcmNoL2FybTY0L2t2bS9NYWtlZmlsZSAgICAgICAgICAgICAg
ICAgICB8ICAgNCArCiBhcmNoL2FybTY0L2t2bS9hcm0uYyAgICAgICAgICAgICAgICAgICAgICB8
ICA0NiArKysrKy0KIGFyY2gvYXJtNjQva3ZtL2h5cC9oeXAtZW50cnkuUyAgICAgICAgICAgIHwg
ICA2ICstCiBhcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9NYWtlZmlsZSAgICAgICAgICB8ICAgNSAr
LQogYXJjaC9hcm02NC9rdm0vaHlwL252aGUvdWJzYW4uYyAgICAgICAgICAgfCAxNjQgKysrKysr
KysrKysrKysrKysrKysrKwogYXJjaC9hcm02NC9rdm0vaHlwL252aGUvdWJzYW5fdGVzdC5jICAg
ICAgfCAxMTUgKysrKysrKysrKysrKysrCiBhcmNoL2FybTY0L2t2bS9rdm1fdWJzYW5fYnVmZmVy
LmMgICAgICAgICB8ICA3NSArKysrKysrKysrCiBsaWIvS2NvbmZpZy51YnNhbiAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgNSArLQogc2NyaXB0cy9NYWtlZmlsZS51YnNhbiAgICAgICAgICAg
ICAgICAgICAgfCAgIDkgKy0KIDE0IGZpbGVzIGNoYW5nZWQsIDU2MSBpbnNlcnRpb25zKCspLCA1
IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20v
a3ZtX2RlYnVnX2J1ZmZlci5oCiBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1fdWJzYW4uaAogY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvYXJtNjQva3ZtL2h5cC9u
dmhlL3Vic2FuLmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2t2bS9oeXAvbnZoZS91
YnNhbl90ZXN0LmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2t2bS9rdm1fdWJzYW5f
YnVmZmVyLmMKCi0tIAoyLjI4LjAuNjE4LmdmNGJjMTIzY2I3LWdvb2cKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

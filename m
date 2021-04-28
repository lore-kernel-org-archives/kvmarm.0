Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCC8C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 15:51:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8F25613B4
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 15:50:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8F25613B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F24AF4B261;
	Wed, 28 Apr 2021 11:50:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Uv9BbH2IEQED; Wed, 28 Apr 2021 11:50:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9CFD4B26F;
	Wed, 28 Apr 2021 11:50:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C16134B261
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 11:50:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f3ZfyL20AkG9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 11:50:53 -0400 (EDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B70BE4B238
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 11:50:53 -0400 (EDT)
Received: by mail-wr1-f49.google.com with SMTP id m9so50848083wrx.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=tRy6KQAd2aytF7sdp/cJx67ONL5QehPERyNmo11ZKWA=;
 b=uuyp8qweDp2flU/K/24W2c3cBGWF24O7u44mz6KIS/kPm9fX6sNtXd+HI5urh0dHz3
 VsoMJUt11ge1kfVwMmiYeYJLiw4mSdtfMmFhyrjbzr8IhJ6tt2nqkOZh+l/LqgQY3ueG
 d32GVQTOwnvfGIzIf5Rhe3wlfoXJehrLCLkmFGCglKeJiF19HJ05K2nGxgC6qQvvBKKv
 z9tI23hA9jQtr+841P/ueKwjBj/l+csxaBROzbnIC8DfzmFBlX9a7N/J4Ix7DIMl/XPD
 oUBDqW9MCd2cQtOLTaoMJkLChHJT0WXEDiVsTBC5ErhPwZwt+PVXkCy2RWiE23yHDmob
 rbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=tRy6KQAd2aytF7sdp/cJx67ONL5QehPERyNmo11ZKWA=;
 b=d/YDWhSAKzOErMpx0jj1J/RsSgOecKPElQ+ojbD6exa4plEDfIDwPVOO3CnwHI3ltk
 kya57xxKrMzBWpH7TEOcrhjDe/XPAJv/zGSm/g0DDZyfanKGShk0nYb8HPKalFckQSOP
 iRlLwoN1dSmPPtaeCOVfgEIvle6vptVABOoe/ofZYK4nlObN/3izY+9yFNI8DQ10rnh8
 zmOpBvlvLzzYNY+Wp71uRtU8mtPxA/jZ4TAKwwGjwH0JPO5Nm2dFFbSUrZJw2YLcTQj3
 fyBKJxdF1ABqnCbn467JgRK1gbb2kE68Unn1DQIME6yJtKUQgGb7Mlh+FSU0wSrJk54X
 hNfw==
X-Gm-Message-State: AOAM530qzy7L1/n1jffNfWfAY/vxgNvRLcbaPiCkglpSvlzmYeui+mBx
 w+QvILAfeh1coFRE3zL2YU6BVg==
X-Google-Smtp-Source: ABdhPJx5fpcX8GYyUuPP7jxE5XxhgdA644hng/G8ehJHMs3ZqzR1d35ZOOopcIAqTcOovOeeWVgpdQ==
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr37234198wrj.420.1619625052579; 
 Wed, 28 Apr 2021 08:50:52 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z15sm159848wrv.39.2021.04.28.08.50.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 08:50:51 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 170071FF7E;
 Wed, 28 Apr 2021 16:50:51 +0100 (BST)
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
 <eaed3c63988513fe2849c2d6f22937af@kernel.org> <87fszasjdg.fsf@linaro.org>
 <996210ae-9c63-54ff-1a65-6dbd63da74d2@arm.com>
 <87k0omo4rr.wl-maz@kernel.org>
User-agent: mu4e 1.5.12; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test
 into KVM and TCG variants
Date: Wed, 28 Apr 2021 16:37:45 +0100
In-reply-to: <87k0omo4rr.wl-maz@kernel.org>
Message-ID: <87czues90k.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
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

Ck1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyaXRlczoKCj4gT24gV2VkLCAyOCBBcHIg
MjAyMSAxNTowMDoxNSArMDEwMCwKPiBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4YW5kcnUuZWxpc2Vp
QGFybS5jb20+IHdyb3RlOgo+PiAKPj4gSSBpbnRlcnByZXQgdGhhdCBhcyB0aGF0IGFuIElOVkFM
TCBndWFyYW50ZWVzIHRoYXQgYSBjaGFuZ2UgaXMKPj4gdmlzaWJsZSwgYnV0IGl0IHRoZSBjaGFu
Z2UgY2FuIGJlY29tZSB2aXNpYmxlIGV2ZW4gd2l0aG91dCB0aGUKPj4gSU5WQUxMLgo+Cj4gWWVz
LiBFeHBlY3RpbmcgdGhlIExQSSB0byBiZSBkZWxpdmVyZWQgb3Igbm90IGluIHRoZSBhYnNlbmNl
IG9mIGFuCj4gaW52YWxpZGF0ZSB3aGVuIGl0cyBjb25maWd1cmF0aW9uIGhhcyBiZWVuIGFsdGVy
ZWQgaXMgd3JvbmcuIFRoZQo+IGFyY2hpdGVjdHVyZSBkb2Vzbid0IGd1YXJhbnRlZSBhbnl0aGlu
ZyBvZiB0aGUgc29ydC4KCklzIHRoZSB1bmRlcmx5aW5nIGh5cGVydmlzb3IgYWxsb3dlZCB0byBp
bnZhbGlkYXRlIGFuZCByZWxvYWQgdGhlCmNvbmZpZ3VyYXRpb24gd2hlbmV2ZXIgaXQgd2FudHMg
b3Igc2hvdWxkIGl0IG9ubHkgYmUgZHJpdmVuIGJ5IHRoZQpndWVzdHMgcmVxdWVzdHM/CgpJIGRp
ZCBjb25zaWRlciBhIG1vcmUgbnVhbmNlZCB2YXJpYW50IG9mIHRoZSB0ZXN0IHRoYXQgYWxsb3dl
ZCBmb3IgYQpkZWxpdmVyeSBwcmUtaW52YWwgYW5kIGEgcGFzcyBmb3IgcG9zdC1pbnZhbCBhcyBs
b25nIGFzIGl0IGhhZCBiZWVuCmRlbGl2ZXJlZCBvbmUgd2F5IG9yIGFub3RoZXI6CgotLTg8LS0t
LS0tLS0tLS0tLS0tY3V0IGhlcmUtLS0tLS0tLS0tLS0tLS1zdGFydC0tLS0tLS0tLS0tLS0+OC0t
LQptb2RpZmllZCAgIGFybS9naWMuYwpAQCAtMzYsNiArMzYsNyBAQCBzdGF0aWMgc3RydWN0IGdp
YyAqZ2ljOwogc3RhdGljIGludCBhY2tlZFtOUl9DUFVTXSwgc3B1cmlvdXNbTlJfQ1BVU107CiBz
dGF0aWMgaW50IGlycV9zZW5kZXJbTlJfQ1BVU10sIGlycV9udW1iZXJbTlJfQ1BVU107CiBzdGF0
aWMgY3B1bWFza190IHJlYWR5Oworc3RhdGljIGJvb2wgdW5kZXJfdGNnOwogCiBzdGF0aWMgdm9p
ZCBucl9jcHVfY2hlY2soaW50IG5yKQogewpAQCAtNjg3LDYgKzY4OCw3IEBAIHN0YXRpYyB2b2lk
IHRlc3RfaXRzX3RyaWdnZXIodm9pZCkKIAlzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKmNvbDM7CiAJ
c3RydWN0IGl0c19kZXZpY2UgKmRldjIsICpkZXY3OwogCWNwdW1hc2tfdCBtYXNrOworCWJvb2wg
YmVmb3JlLCBhZnRlcjsKIAogCWlmIChpdHNfc2V0dXAxKCkpCiAJCXJldHVybjsKQEAgLTczNCwx
NSArNzM2LDE3IEBAIHN0YXRpYyB2b2lkIHRlc3RfaXRzX3RyaWdnZXIodm9pZCkKIAkvKgogCSAq
IHJlLWVuYWJsZSB0aGUgTFBJIGJ1dCB3aWxsaW5nbHkgZG8gbm90IGNhbGwgaW52YWxsCiAJICog
c28gdGhlIGNoYW5nZSBpbiBjb25maWcgaXMgbm90IHRha2VuIGludG8gYWNjb3VudC4KLQkgKiBU
aGUgTFBJIHNob3VsZCBub3QgaGl0CisJICogVGhlIExQSSBzaG91bGQgbm90IGhpdC4gVGhpcyBk
b2VzIGhvd2V2ZXIgZGVwZW5kIG9uCisJICogaW1wbGVtZW50YXRpb24gZGVmaW5lZCBiZWhhdmlv
dXIgLSB1bmRlciBRRU1VIFRDRyBlbXVsYXRpb24KKwkgKiBpdCBjYW4gcXVpdGUgY29ycmVjdGx5
IHByb2Nlc3MgdGhlIGV2ZW50IGRpcmVjdGx5LgogCSAqLwogCWdpY3YzX2xwaV9zZXRfY29uZmln
KDgxOTUsIExQSV9QUk9QX0RFRkFVTFQpOwogCXN0YXRzX3Jlc2V0KCk7CiAJY3B1bWFza19jbGVh
cigmbWFzayk7CiAJaXRzX3NlbmRfaW50KGRldjIsIDIwKTsKIAl3YWl0X2Zvcl9pbnRlcnJ1cHRz
KCZtYXNrKTsKLQlyZXBvcnQoY2hlY2tfYWNrZWQoJm1hc2ssIC0xLCAtMSksCi0JCQkiZGV2Mi9l
dmVudGlkPTIwIHN0aWxsIGRvZXMgbm90IHRyaWdnZXIgYW55IExQSSIpOworCWJlZm9yZSA9IGNo
ZWNrX2Fja2VkKCZtYXNrLCAtMSwgLTEpOworCXJlcG9ydF94ZmFpbCh1bmRlcl90Y2csIGJlZm9y
ZSwgImRldjIvZXZlbnRpZD0yMCBzdGlsbCBtYXkgbm90IHRyaWdnZXIgYW55IExQSSIpOwogCiAJ
LyogTm93IGNhbGwgdGhlIGludmFsbCBhbmQgY2hlY2sgdGhlIExQSSBoaXRzICovCiAJc3RhdHNf
cmVzZXQoKTsKQEAgLTc1MCw4ICs3NTQsOCBAQCBzdGF0aWMgdm9pZCB0ZXN0X2l0c190cmlnZ2Vy
KHZvaWQpCiAJY3B1bWFza19zZXRfY3B1KDMsICZtYXNrKTsKIAlpdHNfc2VuZF9pbnZhbGwoY29s
Myk7CiAJd2FpdF9mb3JfaW50ZXJydXB0cygmbWFzayk7Ci0JcmVwb3J0KGNoZWNrX2Fja2VkKCZt
YXNrLCAwLCA4MTk1KSwKLQkJCSJkZXYyL2V2ZW50aWQ9MjAgcGVuZGluZyBMUEkgaXMgcmVjZWl2
ZWQiKTsKKwlhZnRlciA9IGNoZWNrX2Fja2VkKCZtYXNrLCAwLCA4MTk1KTsKKwlyZXBvcnQoYmVm
b3JlICE9IGFmdGVyLCAiZGV2Mi9ldmVudGlkPTIwIHBlbmRpbmcgTFBJIGlzIHJlY2VpdmVkIik7
CiAKIAlzdGF0c19yZXNldCgpOwogCWNwdW1hc2tfY2xlYXIoJm1hc2spOwpAQCAtNzU5LDcgKzc2
Myw3IEBAIHN0YXRpYyB2b2lkIHRlc3RfaXRzX3RyaWdnZXIodm9pZCkKIAlpdHNfc2VuZF9pbnQo
ZGV2MiwgMjApOwogCXdhaXRfZm9yX2ludGVycnVwdHMoJm1hc2spOwogCXJlcG9ydChjaGVja19h
Y2tlZCgmbWFzaywgMCwgODE5NSksCi0JCQkiZGV2Mi9ldmVudGlkPTIwIG5vdyB0cmlnZ2VycyBh
biBMUEkiKTsKKwkgICAgICAgImRldjIvZXZlbnRpZD0yMCBub3cgdHJpZ2dlcnMgYW4gTFBJIik7
CiAKIAlyZXBvcnRfcHJlZml4X3BvcCgpOwogCkBAIC05ODEsNiArOTg1LDkgQEAgaW50IG1haW4o
aW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCWlmIChhcmdjIDwgMikKIAkJcmVwb3J0X2Fib3J0KCJu
byB0ZXN0IHNwZWNpZmllZCIpOwogCisJaWYgKGFyZ2MgPT0gMyAmJiBzdHJjbXAoYXJndlsyXSwg
InRjZyIpID09IDApCisJCXVuZGVyX3RjZyA9IHRydWU7CisKIAlpZiAoc3RyY21wKGFyZ3ZbMV0s
ICJpcGkiKSA9PSAwKSB7CiAJCXJlcG9ydF9wcmVmaXhfcHVzaChhcmd2WzFdKTsKIAkJbnJfY3B1
X2NoZWNrKDIpOwotLTg8LS0tLS0tLS0tLS0tLS0tY3V0IGhlcmUtLS0tLS0tLS0tLS0tLS1lbmQt
LS0tLS0tLS0tLS0tLS0+OC0tLQoKQnV0IHRoYXQgZ2V0cyBjb25mdXNlZCAodGhhdCBtYXkgYmUg
c29tZXRoaW5nIGZvciBTYXNoaSB0byBsb29rIGF0KToKCiAgSVRTOiBNQVBEIGRldmlkPTIgc2l6
ZSA9IDB4OCBpdHQ9MHg0MDQ0MDAwMCB2YWxpZD0xCiAgSVRTOiBNQVBEIGRldmlkPTcgc2l6ZSA9
IDB4OCBpdHQ9MHg0MDQ1MDAwMCB2YWxpZD0xCiAgTUFQQyBjb2xfaWQ9MyB0YXJnZXRfYWRkciA9
IDB4MzAwMDAgdmFsaWQ9MQogIE1BUEMgY29sX2lkPTIgdGFyZ2V0X2FkZHIgPSAweDIwMDAwIHZh
bGlkPTEKICBJTlZBTEwgY29sX2lkPTIKICBJTlZBTEwgY29sX2lkPTMKICBNQVBUSSBkZXZfaWQ9
MiBldmVudF9pZD0yMCAtPiBwaHlzX2lkPTgxOTUsIGNvbF9pZD0zCiAgTUFQVEkgZGV2X2lkPTcg
ZXZlbnRfaWQ9MjU1IC0+IHBoeXNfaWQ9ODE5NiwgY29sX2lkPTIKICBJTlQgZGV2X2lkPTIgZXZl
bnRfaWQ9MjAKICBQQVNTOiBnaWN2MzogaXRzLXRyaWdnZXI6IGludDogZGV2PTIsIGV2ZW50aWQ9
MjAgIC0+IGxwaT0gODE5NSwgY29sPTMKICBJTlQgZGV2X2lkPTcgZXZlbnRfaWQ9MjU1CiAgUEFT
UzogZ2ljdjM6IGl0cy10cmlnZ2VyOiBpbnQ6IGRldj03LCBldmVudGlkPTI1NSAtPiBscGk9IDgx
OTYsIGNvbD0yCiAgSU5WIGRldl9pZD0yIGV2ZW50X2lkPTIwCiAgSU5UIGRldl9pZD0yIGV2ZW50
X2lkPTIwCiAgUEFTUzogZ2ljdjM6IGl0cy10cmlnZ2VyOiBpbnYvaW52YWxsOiBkZXYyL2V2ZW50
aWQ9MjAgZG9lcyBub3QgdHJpZ2dlciBhbnkgTFBJCiAgSU5UIGRldl9pZD0yIGV2ZW50X2lkPTIw
CiAgSU5GTzogZ2ljdjM6IGl0cy10cmlnZ2VyOiBpbnYvaW52YWxsOiBpbnRlcnJ1cHRzIHRpbWVk
LW91dCAoNXMpCiAgSU5GTzogZ2ljdjM6IGl0cy10cmlnZ2VyOiBpbnYvaW52YWxsOiBjcHUzIHJl
Y2VpdmVkIHdyb25nIGlycSA4MTk1CiAgSU5GTzogZ2ljdjM6IGl0cy10cmlnZ2VyOiBpbnYvaW52
YWxsOiBBQ0tTOiBtaXNzaW5nPTAgZXh0cmE9MCB1bmV4cGVjdGVkPTEKICBYRkFJTDogZ2ljdjM6
IGl0cy10cmlnZ2VyOiBpbnYvaW52YWxsOiBkZXYyL2V2ZW50aWQ9MjAgc3RpbGwgbWF5IG5vdCB0
cmlnZ2VyIGFueSBMUEkKICBJTlZBTEwgY29sX2lkPTMKICBJTkZPOiBnaWN2MzogaXRzLXRyaWdn
ZXI6IGludi9pbnZhbGw6IGludGVycnVwdHMgdGltZWQtb3V0ICg1cykKICBJTkZPOiBnaWN2Mzog
aXRzLXRyaWdnZXI6IGludi9pbnZhbGw6IEFDS1M6IG1pc3Npbmc9MSBleHRyYT0wIHVuZXhwZWN0
ZWQ9MAogIEZBSUw6IGdpY3YzOiBpdHMtdHJpZ2dlcjogaW52L2ludmFsbDogZGV2Mi9ldmVudGlk
PTIwIHBlbmRpbmcgTFBJIGlzIHJlY2VpdmVkCiAgSU5UIGRldl9pZD0yIGV2ZW50X2lkPTIwCiAg
UEFTUzogZ2ljdjM6IGl0cy10cmlnZ2VyOiBpbnYvaW52YWxsOiBkZXYyL2V2ZW50aWQ9MjAgbm93
IHRyaWdnZXJzIGFuIExQSQogIElUUzogTUFQRCBkZXZpZD0yIHNpemUgPSAweDggaXR0PTB4NDA0
NDAwMDAgdmFsaWQ9MAogIElOVCBkZXZfaWQ9MiBldmVudF9pZD0yMAogIFBBU1M6IGdpY3YzOiBp
dHMtdHJpZ2dlcjogbWFwZCB2YWxpZD1mYWxzZTogbm8gTFBJIGFmdGVyIGRldmljZSB1bm1hcAog
IFNVTU1BUlk6IDcgdGVzdHMsIDEgdW5leHBlY3RlZCBmYWlsdXJlcywgMSBleHBlY3RlZCBmYWls
dXJlcwoKPj4gVGhlIHRlc3QgcmVsaWVzIG9uIHRoZSBmYWN0IHRoYXQgY2hhbmdlcyB0byB0aGUg
TFBJIHRhYmxlcyBhcmUgbm90Cj4+IHZpc2libGUgKnVuZGVyIEtWTSogdW50aWwgdGhlIElOVkFM
TCBjb21tYW5kLCBidXQgdGhhdCdzIG5vdAo+PiBuZWNlc3NhcmlseSB0aGUgY2FzZSBvbiByZWFs
IGhhcmR3YXJlLiBUbyBtYXRjaCB0aGUgc3BlYywgSSB0aGluawo+PiB0aGUgdGVzdCAiZGV2Mi9l
dmVudGlkPTIwIHN0aWxsIGRvZXMgbm90IHRyaWdnZXIgYW55IExQSSIgc2hvdWxkIGJlCj4+IHJl
bW92ZWQgYW5kIHRoZSBzdGF0cyByZXNldCBzaG91bGQgdGFrZSBwbGFjZSBiZWZvcmUgdGhlCj4+
IGNvbmZpZ3VyYXRpb24gZm9yIExQSSA4MTk1IGlzIHNldCB0byB0aGUgZGVmYXVsdC4KPgo+IElm
IHRoYXQncyB3aGF0IHRoZSB0ZXN0IGV4cGVjdHMgKEkgaGF2ZW4ndCB0cmllZCB0byBpbnZlc3Rp
Z2F0ZSksIGl0Cj4gc2hvdWxkIGJlIGRyb3BwZWQgY29tcGxldGVseSwgcmF0aGVyIHRoYW4gdHJ5
aW5nIHRvIHNpZGVzdGVwIGl0IGZvcgo+IFRDRy4KCkFsbCB0aHJlZSBwYXJ0cyBvZiB0aGF0IHNl
Y3Rpb24/CgoJcmVwb3J0KGNoZWNrX2Fja2VkKCZtYXNrLCAtMSwgLTEpLAoJCQkiZGV2Mi9ldmVu
dGlkPTIwIHN0aWxsIGRvZXMgbm90IHRyaWdnZXIgYW55IExQSSIpOwoJcmVwb3J0KGNoZWNrX2Fj
a2VkKCZtYXNrLCAwLCA4MTk1KSwKCQkJImRldjIvZXZlbnRpZD0yMCBwZW5kaW5nIExQSSBpcyBy
ZWNlaXZlZCIpOwoJcmVwb3J0KGNoZWNrX2Fja2VkKCZtYXNrLCAwLCA4MTk1KSwKCQkJImRldjIv
ZXZlbnRpZD0yMCBub3cgdHJpZ2dlcnMgYW4gTFBJIik7CgoKLS0gCkFsZXggQmVubsOpZQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D887FC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 14:09:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5611C61027
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 14:09:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5611C61027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B37C4B2B4;
	Fri, 12 Nov 2021 09:09:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Is8qNhDO-wKW; Fri, 12 Nov 2021 09:09:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 935A34B2BA;
	Fri, 12 Nov 2021 09:09:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D040F4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 09:08:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u3WAphAfAvPS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 09:08:57 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A2D24B28F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 09:08:57 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id
 az33-20020a05600c602100b00333472fef04so9212112wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=LvcYQf11PARVGCPaBocJIwE2u4Koi7pmpNUlWEMd4Cs=;
 b=L2J4Dq6FxomGl67aZpSolpe2vs6NVpgH6dJgY+slakbQHyj4vHP0WTbo2DeihNmCeF
 o6ukr4f2ga6HH91i/v0yrUWl0bQtrj3xt02aCQ3OKaOWxDI5q85DbenR10rWCTfWAXyF
 nL3XHvQOtWRgv9hb62SJwgAhaqlfrJp69iAK97QUeg2KZbvUAFW20EWf780eI+c7eGjQ
 kdZhnFSpsQy1ZpbuR3nqIXpR2kYVPOB57U/0exwFS8KDw0Vi+PhkLYR6p2qvapphvtDh
 AbfPaHT3wEEQ8eOKxnmjeLSvErZZ1sABEMwC/3jIM/ehniVXbq2N77pl3/umyiOvMlqg
 zcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=LvcYQf11PARVGCPaBocJIwE2u4Koi7pmpNUlWEMd4Cs=;
 b=4flYheMul+Hgfh018ASN8lJirEBfq6wO8uNXfU8lf+2CZ8J0bhuWViX38OaaL1Lbnw
 NwIorreU8GyL+0BN5YLz6eFBHr+5MH0GrCD8lT+1EviV0DA9XSlqplbfcdHfdinbLX7r
 E+k5kZ45p3vqY6DEn1OSU25M0xotQEtuuU14mHXL2VcOjPdwjpijO8+nKNYixXx/HhpC
 wxzdXF7DVkqrmi7pLg/94x3JMEk4vMfTRUr3MvZsVtyujhCp89ENGfg7XR6zH2vhUSju
 WUh1RfP9fBunHPnSbnxBuBY/Nk4nhbkWeVhtZIWMR42JberlwRuyTpfZAz2n8JwpUfJU
 pFnA==
X-Gm-Message-State: AOAM533QRnbWV5JnKJhyaVAlWbu0c9ELMeXUiP28A1WFl2bo2pEA/pB8
 T4e2BbqkH25i8ymokMFurRTLJQ==
X-Google-Smtp-Source: ABdhPJxLKpfOe7BU/uBpUgsE7avktdh1qKpR60mHaE8U1RGlwiGEstkhWhMJmbfqohLiP9Q2KZVxHw==
X-Received: by 2002:a05:600c:17c3:: with SMTP id
 y3mr33939958wmo.136.1636726132597; 
 Fri, 12 Nov 2021 06:08:52 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id q4sm5912967wrs.56.2021.11.12.06.08.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 06:08:51 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id B88221FF96;
 Fri, 12 Nov 2021 14:08:50 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
User-agent: mu4e 1.7.4; emacs 28.0.60
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date: Fri, 12 Nov 2021 14:08:01 +0000
In-reply-to: <20211112132312.qrgmby55mlenj72p@gator.home>
Message-ID: <87wnldfoul.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIEZyaSwgTm92
IDEyLCAyMDIxIGF0IDExOjQ3OjMxQU0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gSGks
Cj4+IAo+PiBTb3JyeSB0aGlzIGhhcyBiZWVuIHNpdHRpbmcgaW4gbXkgdHJlZSBzbyBsb25nLiBU
aGUgY2hhbmdlcyBhcmUgZmFpcmx5Cj4+IG1pbm9yIGZyb20gdjIuIEkgbm8gbG9uZ2VyIHNwbGl0
IHRoZSB0ZXN0cyB1cCBpbnRvIFRDRyBhbmQgS1ZNCj4+IHZlcnNpb25zIGFuZCBpbnN0ZWFkIGp1
c3QgZW5zdXJlIHRoYXQgRVJSQVRBX0ZPUkNFIGlzIGFsd2F5cyBzZXQgd2hlbgo+PiBydW4gdW5k
ZXIgVENHLgo+PiAKPj4gQWxleCBCZW5uw6llICgzKToKPj4gICBhcm02NDogcmVtb3ZlIGludmFs
aWQgY2hlY2sgZnJvbSBpdHMtdHJpZ2dlciB0ZXN0Cj4+ICAgYXJtNjQ6IGVuYWJsZSBpdHMtbWln
cmF0aW9uIHRlc3RzIGZvciBUQ0cKPj4gICBhcmNoLXJ1bjogZG8gbm90IHByb2Nlc3MgRVJSQVRB
IHdoZW4gcnVubmluZyB1bmRlciBUQ0cKPj4gCj4+ICBzY3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAg
NCArKystCj4+ICBhcm0vZ2ljLmMgICAgICAgICAgICAgfCAxNiArKysrKystLS0tLS0tLS0tCj4+
ICBhcm0vdW5pdHRlc3RzLmNmZyAgICAgfCAgMyAtLS0KPj4gIDMgZmlsZXMgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKPj4gCj4+IC0tIAo+PiAyLjMwLjIKPj4gCj4+
IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4+IGt2bWFy
bSBtYWlsaW5nIGxpc3QKPj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQo+PiBodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo+Cj4gSGkgQWxl
eCwKPgo+IFRoYW5rcyBmb3IgdGhpcy4gSSd2ZSBhcHBsaWVkIHRvIGFybS9xdWV1ZSwgYnV0IEkg
c2VlIHRoYXQKPgo+IEZBSUw6IGdpY3YzOiBpdHMtdHJpZ2dlcjogaW52L2ludmFsbDogZGV2Mi9l
dmVudGlkPTIwIHBlbmRpbmcgTFBJIGlzIHJlY2VpdmVkCj4KPiBjb25zaXN0ZW50bHkgZmFpbHMg
Zm9yIG1lLiBJcyB0aGF0IGV4cGVjdGVkPyBEb2VzIGl0IHdvcmsgZm9yIHlvdT8KCmRvaCAtIGxv
b2tzIGxpa2UgSSBjb2NrZWQgdXAgdGhlIG1lcmdlIGNvbmZsaWN0Li4uCgpEaWQgaXQgZmFpbCBm
b3IgVENHIG9yIGZvciBLVk0gKG9yIGJvdGgpPwoKLS0gCkFsZXggQmVubsOpZQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

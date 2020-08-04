Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82660C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 15:40:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 113C3207FC
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 15:40:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UhxrF8BW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 113C3207FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6513F4B591;
	Tue,  4 Aug 2020 11:40:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lUtjwSK2GeGj; Tue,  4 Aug 2020 11:40:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C134B5C2;
	Tue,  4 Aug 2020 11:40:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC1B4B584
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 11:40:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q642IXwgjViK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 11:40:12 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32C854B531
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 11:40:11 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id y3so37846963wrl.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2020 08:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:in-reply-to:date
 :message-id:mime-version:content-transfer-encoding;
 bh=+xqFoCQQoa6eAiMo50Uy9HC91LgUQEIMjIx3DBlCRwg=;
 b=UhxrF8BWf2l+4DIHmMKF00sQXo8svgIiLw4wfiT0UFAkEZGCKIqFtslV1c2kRtGlqQ
 nObO2HKC3Mj6IC+86y8xR8g+5888z59r/fHaEqxFhzK+3oWbidT5LallCb9JyDmgB9zS
 +ngxNEdKVlV3KMiZJ4ZMqrD8ew6SRgICco4g0fPoAYtGL4FxOZYROuRumhj1W7GqZckv
 7dmBPTMLO1R8Ei/Z8q55dDEP6OJc+R52TXXYErh7advHtW34287efJjtaZlKyTvm4TOY
 h5GmRLoCvngNzxR/BHnJxFbtL/yhw/IwGqibGjaIMr6h9rPOZTGy75dl3HwKRPYr2ijR
 eUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject
 :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
 bh=+xqFoCQQoa6eAiMo50Uy9HC91LgUQEIMjIx3DBlCRwg=;
 b=JxtXzJuMXvv9HgIBYMKRAmi1crFZNJD2Q3bhISU7C6Jo38OtgZCWYoZ/XB2KFAXbbt
 wthUOKoOb0gUInJ9w25ySU9bFZxHdAhIPO4OB5dmskcOUIKkjOQ21prlCqrjaCl5x8CT
 GGPHKuOtAeA+0WrB6TQf1lqwSlYLKNcU1vzT5H0nyGanixANExclz0Ww81lBRjTOUZZF
 f00IF2xmt4hVbRm7/3zE8TFXg2o6m7amvLac//iVnKWoD67b+bfKxA+LGRC0H6oRxcMR
 omXyfeyXCtpWVZHAIete9YkLDzZcFB7iOvA2eshaSXQVzjtFlbWazRTqmhohLvjPKfMF
 H3Kw==
X-Gm-Message-State: AOAM533sbRZXM5C5mjQVBHLjfR6OrWjUFAoRQ5tuHtlUxmgfaBMNTqtx
 6M5uRqKVbawFzCatsVziO69H3A==
X-Google-Smtp-Source: ABdhPJzJKsRHYbdxphNd2Y+U/MaVHkKnNns4heTa05XV+GsGcSREvqMNGKYzebFV5HdOfY82dOrLMA==
X-Received: by 2002:a5d:51c3:: with SMTP id n3mr20350026wrv.104.1596555610319; 
 Tue, 04 Aug 2020 08:40:10 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id a10sm30539397wrx.15.2020.08.04.08.40.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Aug 2020 08:40:08 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id A1FA31FF7E;
 Tue,  4 Aug 2020 16:40:07 +0100 (BST)
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
 <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org> <87r1smmpw5.fsf@linaro.org>
 <b78f8715bbaec8fc728a85d614b00688@kernel.org>
User-agent: mu4e 1.5.5; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-reply-to: <b78f8715bbaec8fc728a85d614b00688@kernel.org>
Date: Tue, 04 Aug 2020 16:40:07 +0100
Message-ID: <87lfiumnc8.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Ck1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyaXRlczoKCj4gT24gMjAyMC0wOC0wNCAx
NTo0NCwgQWxleCBCZW5uw6llIHdyb3RlOgo+PiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3Jn
PiB3cml0ZXM6Cj4+IAo+Pj4gT24gMjAyMC0wOC0wNCAxMzo0NCwgQWxleCBCZW5uw6llIHdyb3Rl
Ogo+Pj4+IFRoZSBWSVJUSU9fUENJIHN1cHBvcnQgaXMgYW4gaWRlYWxpc2VkIFBDSSBidXMsIHdl
IGRvbid0IG5lZWQgYSBidW5jaAo+Pj4+IG9mIGJsb2F0IGZvciByZWFsIHdvcmxkIGhhcmR3YXJl
IGZvciBhIFZpcnRJTyBndWVzdC4KPj4+IAo+Pj4gV2hvIHNheXMgdGhpcyBndWVzdCB3aWxsIG9u
bHkgaGF2ZSB2aXJ0aW8gZGV2aWNlcz8KPj4gCj4+IFRoaXMgaXMgdHJ1ZSAtIGFsdGhvdWdoIHdo
YXQgaXMgdGhlIHBvaW50IG9mIGt2bV9ndWVzdC5jb25maWc/IFdlCj4+IGNlcnRhaW5seSB0dXJu
IG9uIGEgd2hvbGUgYnVuY2ggb2YgdmlydCBvcHRpbWlzZWQgcGF0aHdheXMgd2l0aCAKPj4gUEFS
QVZJUlQKPj4gYW5kIEhZUEVSVklTT1JfR1VFU1QgYWxvbmcgd2l0aCB0aGUgcmVzdCBvZiBWaXJ0
SU8uCj4KPiBNb3N0IG9mIHdoaWNoIGFjdHVhbGx5IHF1YWxpZmllcyBhcyBibG9hdCBpdHNlbGYg
YXMgZmFyIGFzIEtWTS9hcm02NAo+IGlzIGNvbmNlcm5lZC4uLgoKU28gaGVyZSBpcyB0aGUgcXVl
c3Rpb24gLSBkb2VzIHRoZSBrZXJuZWwgY2FyZSBhYm91dCBoYXZpbmcgYSBibGVzc2VkCmNvbmZp
ZyBmb3IgYSBtaW5pbWFsIHZpYWJsZSBndWVzdD8gVGhleSBhcmUgY2VydGFpbmx5IHVzZWQgaW4g
dGhlIGNsb3VkCmJ1dCBJIHVuZGVyc3RhbmQgdGhlIGtlcm5lbCBpcyB0cnlpbmcgdG8gZ2V0IGF3
YXkgZnJvbSBoYXZpbmcgYSB6b28gb2YKY29uZmlncy4gV2hhdCBpcyB0aGUgYWN0dWFsIHBvaW50
IG9mIGt2bV9ndWVzdC5jb25maWc/IEp1c3QgYW4gZWFzeQplbmFibGluZyBmb3IgZGV2ZWxvcGVy
cz8KCj4KPiAgICAgICAgICAgTS4KCgotLSAKQWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=

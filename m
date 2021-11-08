Return-Path: <SRS0=McOM=P3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925D2C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 19:45:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05903619E2
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 19:45:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05903619E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7815E4B173;
	Mon,  8 Nov 2021 14:45:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HcCdU4iZSlqs; Mon,  8 Nov 2021 14:45:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5874A4B1A2;
	Mon,  8 Nov 2021 14:45:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A51A4B190
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 14:45:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qh58IxEP2caN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 14:45:29 -0500 (EST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E30044B118
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 14:45:28 -0500 (EST)
Received: by mail-lf1-f46.google.com with SMTP id y26so38722283lfa.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 11:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :content-transfer-encoding;
 bh=M2JY9gaKo77jdrktluhOErsfxi1flP79RXbRXEX24Rk=;
 b=emD7B4U8XMd3wp4vJRY/tkwqWcYtHLDUe8WFpz2g5oR5oLGNuCfiuonc49JQuk4MEp
 L1W8OVcYDebbCjVxqjMu9LrlnkR4Yki0R9LH/O6AIx/Xe+cnxkeLXJ4XeRCbBIPHG6bF
 CkCgeDGhTbM+p/k9ICLKihKw+pKqunYKqW3XobYsBbMupKgSVs1j0x0wt90Vg7dLoKef
 ffdazSrxLTjn7EA5o0O5CVW9KqkPOy8DgVhFC0LY5OJiGb6HhmSyNhbCLJrUbE5MDcFn
 EHfVk6hGHSRGyWuCdaZT8UnL5AGE8PDwrmPiwUuqx53PcIJaiDkdkXZSMXHyVmdjSQlu
 BZnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:content-transfer-encoding;
 bh=M2JY9gaKo77jdrktluhOErsfxi1flP79RXbRXEX24Rk=;
 b=Ijueak5Bmq0Odb33WxaMOLwDu186ynOxqT/o/kPiadOet7gnueFDQh0L6xCQF4M396
 gtsMh72lTlH5oEp/0u1aKwi7z26TEI7RMMUWH96wFUDjVkJaSXPGOIn5X9BFwYF/1m0Y
 fqaE9O/VbkOimwvfiAGy1w3UxY6LEMeeWx6B58SrTelbAt5pWxGX/rmohep3/SZwzMhC
 YHwqutyR4xiHH3roKhrDH7pJrz1HIC9gAsZPANOxPcFb7bNeZ1ITgGsXIhhSt+1tky5Y
 xXg6qtV8awbCFthK5XAbTJR4DcrdrkRLrWCw/XE3kSHWJ/2OLcueNEtl/wpw4dx9MWId
 AQ1g==
X-Gm-Message-State: AOAM531ywdQudeEWRoheZXR9nnpVbe6dMmkKmXw4ISGVT2VCpbmoibEd
 ZU8l1JrXRmzsAy2Z2/ITB4RABQArJo/RJh9hWeYSd0ocQyQ=
X-Google-Smtp-Source: ABdhPJz7zdjtbTxLx3aOqGBzbVOTG72Pw6crBtq6AQ98SW29EaJDGDzuWJ5sePKCTZoLypxwLQp5s9jbZVMiDylsHdI=
X-Received: by 2002:a05:6512:6c7:: with SMTP id
 u7mr1611353lff.261.1636400727392; 
 Mon, 08 Nov 2021 11:45:27 -0800 (PST)
MIME-Version: 1.0
References: <CAFLP=uBWCsV3A_9BnUiyA05_kwg5e8XCSgVOaSX8MZMZjdKCpw@mail.gmail.com>
In-Reply-To: <CAFLP=uBWCsV3A_9BnUiyA05_kwg5e8XCSgVOaSX8MZMZjdKCpw@mail.gmail.com>
From: Chenxu Wang <irakatz51@gmail.com>
Date: Tue, 9 Nov 2021 03:45:16 +0800
Message-ID: <CAFLP=uADgbHKx893yd3=r2f0dthJpLqp5kFvTFP1S5E70yZbDg@mail.gmail.com>
Subject: Re: How to translate a VA in Guest to PA in Host?
To: kvmarm@lists.cs.columbia.edu
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

U29ycnksIEkgaGF2ZSBmb3VuZCBzb21lIHVzZWZ1bCBBUElzIGluIGt2bV9ob3N0LmgsIGJ1dCBJ
IGFtIHN0aWxsCnVuYWJsZSB0byBnZXQgdGhlIGNvcnJlY3QgcmVzdWx0LgpIZXJlIGFyZSBteSB0
ZXN0cy4KCkZpcnN0IEkgYWxsb2NhdGUgYSBwYWdlIGluIEd1ZXN0IE9TLCB3aXRoIEFQSSAidTY0
Cmd2YT1fX2dldF9mcmVlX3BhZ2VzKCkiLiBJIGFsc28gZ2V0IHRoZSBQQSBvZiB0aGUgcGFnZSBi
eSB1c2luZyB0aGUKaW5zdHJ1Y3Rpb24gIkFUIFMxRTFSIihtYXliZSBpdCBpcyBjYWxsZWQgImdw
YSIpLgpOZXh0LCBJIGdlbmVyYXRlIGFuIGV4Y2VwdGlvbiwgd2hpY2ggd2lsbCBiZSBjYXVnaHQg
YnkgS1ZNLCBJIGFsc28KcGFzcyB0aGUgUEEgYXMgYSBwYXJhbWV0ZXIuClRoZW4gSSB1c2UgcGZu
X3RvX2hwYShnZm5fdG9fcGZuKHZjcHUtPmt2bSxncGE+PlBBR0VfU0hJRlQpKSB0byBnZXQKdGhl
IGhwYSwgYnV0IEkgb25seSBnZXQgMC4KCklzIHRoZXJlIHNvbWV0aGluZyB3cm9uZz8KClNpbmNl
cmVseSwKV2FuZyBDaGVueHUKCkNoZW54dSBXYW5nIDxpcmFrYXR6NTFAZ21haWwuY29tPiDkuo4y
MDIx5bm0MTHmnIg55pel5ZGo5LqMIOS4iuWNiDEyOjQy5YaZ6YGT77yaCj4KPiBIaSBhbGwsCj4g
SSBhbSB0cnlpbmcgdG8gdHJhbnNsYXRlIGEgVmlydHVhbCBBZGRyZXNzIGluIEd1ZXN0IE9TIHRv
IHRoZSBQaHlzaWNhbAo+IEFkZHJlc3MgaW4gSG9zdCBPUy4gQ3VycmVudGx5LCBJIGVuYWJsZSB0
aGUgVkhFIGV4dGVuc2lvbiwgc28gdGhlIEhvc3QKPiBpcyBpbiBFTDIuIEkgYWxzbyBlbmFibGUg
RUwyIFN0YWdlLTEgdHJhbnNsYXRpb24gYW5kIEVMMSBTdGFnZS0yCj4gdHJhbnNsYXRpb24uCj4K
PiBJbiBteSBleHBlcmltZW50LCBJIGZpcnN0IGdldCB0aGUgVkEgaW4gR3Vlc3QgT1MuIFRoZW4s
IEkgZ2VuZXJhdGUgYW4KPiBleGNlcHRpb24gdGhhdCB3aWxsIGJlIGNhdWdodCBieSBIb3N0IEtW
TSwgYW5kIHNlbmQgdGhlIHZhbHVlIGFzIGEKPiBwYXJhbWV0ZXIgdG8gdGhlIEhvc3QuCj4gSW4g
S1ZNLCBJIHdhbnQgdG8gdXNlIHRoZSAiQVQgUzEyRTFSIiBmb3IgdGhpcyB2YWx1ZSwgYnV0IGl0
IGZhaWxlZC4KPgo+IFNvLCBkb2VzIEtWTSBpbXBsZW1lbnQgc29tZSBBUEkgb2YgaXQ/Cj4KPiBT
aW5jZXJlbHksCj4gV2FuZyBDaGVueHUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==

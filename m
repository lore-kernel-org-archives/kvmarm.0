Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1CBC2BA2B
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:44:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2194420787
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YTCccdod"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2194420787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 641F94B1DF;
	Fri, 10 Apr 2020 03:44:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yVzmByZv5jKy; Fri, 10 Apr 2020 03:43:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E89C4B19D;
	Fri, 10 Apr 2020 03:43:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D04B64B0B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 00:49:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ReBQ9Swi5lnR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 00:49:22 -0400 (EDT)
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4BBC4B086
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 00:49:22 -0400 (EDT)
Received: by mail-pg1-f195.google.com with SMTP id g6so518429pgs.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Apr 2020 21:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=mgQP5fmEp3MLJlgjlz6jaeSibt5vSyFPfuJ0XoZcVIE=;
 b=YTCccdodR7/n1FEyARWl3Q04RpXd2xuQdfe6IsTM12uKGt3usSyb2eI5D/mUXyhg+C
 xuGZYqPVKMhumQ92IfZVyl92N4kyqYQfGA3a91Wg3UaISaKEKqMCoZeKJjDY9wRafAE6
 PkbaMayND2HOLKolooArZg6Mq2xIo0mfnSbXvwYLzgzPN9IiFqgjfjT8foeD2QzjbX5Y
 v2lrgetZH/0qCp+TuiaFSKpAowRrruA7Te0oBpmMf1XmmJsLb9m98HA+h5hnguqYbzgR
 xCI0zpEBq2WE4tNV8g/dhJpyIFjCOeENUnGHlWUuXCRLYK3FxdG7SaPXHQg+C4swiXuU
 Muqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=mgQP5fmEp3MLJlgjlz6jaeSibt5vSyFPfuJ0XoZcVIE=;
 b=L2yqnYmXr9yXrJEZ5JPE0ob0OEMScCoPe96N4oc8QUzrDPG7yNoyIoaE4f9M64UFry
 Agfi8YrtiM6MZQWaKNoQBHUXXqwuJjg7gjzzaLlj7VKg9XM7QLh1z6IFSdEH7BvTltv6
 +3GhkDtH+/uvkU/R8rWepE6PbfVbUs5octrc2/CYvZyvOH7wbU7WoOfF4rvJAuk8fSPp
 Z9VzRVUM0J2gD7EORJkJqSAhJPosAFrnoKjjgXCgNn4kGEm9V0PAi8T/aEiMObPDcndY
 uPrtlpwEyGGCMl6totx1Q5MPhVLyGp+MVjAnuMeIzJB8xs5dX9werbEhRQFoCLuxEOC4
 T/Bw==
X-Gm-Message-State: AGi0PubbS3ncEUVgaJDa+jqeB0cKuVj+Yd7OYNWKUDeglovw5vynbt2+
 gGXb5dLWEOTA0aEwdZeOXBoAuKr5jlUyOK1+npc=
X-Google-Smtp-Source: APiQypLgdOSROqVPX4hxkv96w6ogMSeFmpGa0LlYofDEikdwsEdgCSZlL+LUYeyIdfrENnWxg8/peU7nWNBv4uzIIm0=
X-Received: by 2002:a63:8e44:: with SMTP id k65mr2728717pge.452.1586494161789; 
 Thu, 09 Apr 2020 21:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
 <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
In-Reply-To: <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
From: Javier Romero <xavinux@gmail.com>
Date: Fri, 10 Apr 2020 01:49:10 -0300
Message-ID: <CAEX+82L-Kc6W1KOgPGo3JTxvjnOGsjDWm0Z3-c59EDdL4jO+Yw@mail.gmail.com>
Subject: Re: Contribution to KVM.
To: Nadav Amit <nadav.amit@gmail.com>
X-Mailman-Approved-At: Fri, 10 Apr 2020 03:43:52 -0400
Cc: like.xu@intel.com, Liran Alon <liran.alon@oracle.com>,
 kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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

SGkgTmFkYXYsCgpUaGFuayB5b3UgZm9yIHlvdXIgYW5zd2VyLAoKV2lsbCBhbHNvIHRha2UgYSBs
b29rIGF0IHRoZSB0ZXN0IGJ1ZyB5b3Ugc3VnZ2VzdGVkLgoKUmVnYXJkcywKCgpKYXZpZXIgUm9t
ZXJvCgoKCkVsIHZpZS4sIDEwIGFici4gMjAyMCBhIGxhcyAwOjUzLCBOYWRhdiBBbWl0ICg8bmFk
YXYuYW1pdEBnbWFpbC5jb20+KSBlc2NyaWJpw7M6Cj4KPiA+IE9uIEFwciA5LCAyMDIwLCBhdCA4
OjM0IFBNLCBYdSwgTGlrZSA8bGlrZS54dUBpbnRlbC5jb20+IHdyb3RlOgo+ID4KPiA+IE9uIDIw
MjAvNC8xMCA1OjI5LCBKYXZpZXIgUm9tZXJvIHdyb3RlOgo+ID4+IEhlbGxvLAo+ID4+Cj4gPj4g
IE15IG5hbWUgaXMgSmF2aWVyLCBsaXZlIGluIEFyZ2VudGluYSBhbmQgd29yayBhcyBhIGNsb3Vk
IGVuZ2luZWVyLgo+ID4+Cj4gPj4gSGF2ZSBiZWVuIHdvcmtpbmcgd2l0aCBMaW51eCBzZXJ2ZXJz
IGZvciB0aGUgbGFzdCAxMCB5ZWFycyBpbiBhbgo+ID4+IEludGVybmV0IFNlcnZpY2UgUHJvdmlk
ZXIgYW5kIEknbSBpbnRlcmVzdGVkIGluIGNvbnRyaWJ1dGluZyB0byBLVk0KPiA+IFdlbGNvbWUs
IEknbSBhIG5ld2JpZSBhcyB3ZWxsLgo+ID4+IG1heWJlIHdpdGggdGVzdGluZyBhcyBhIHN0YXJ0
IHBvaW50Lgo+ID4gWW91IG1heSB0cnkgdGhlIGh0dHA6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L3ZpcnQva3ZtL2t2bS11bml0LXRlc3RzLmdpdAo+ID4gYW5kIHRvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2t2bSBpbiB0aGUga2VybmVsIHRyZWUuCj4gPj4gSWYgaXQgY2FuIGJlIHVzZWZ1bCB0byB0
ZXN0IEtWTSBvbiBBUk0sIEkgaGF2ZSBhIFJhc3BiZXJyeSBQSSAzIGF0IGRpc3Bvc2FsLgo+ID4g
SWYgeW91IHRlc3QgS1ZNIG9uIEludGVsIHBsYXRmb3JtcywgeW91IHdpbGwgZGVmaW5pdGVseSBn
ZXQgc3VwcG9ydCBmcm9tIG1lIDpELgo+Cj4gSWYgeW91IGFyZSBsb29raW5nIGZvciBzb21ldGhp
bmcgc3BlY2lmaWMsIGhlcmUgYXJlIHR3byBpc3N1ZXMgd2l0aAo+IHJlbGF0aXZlbHkgbGltaXRl
ZCBzY29wZSwgd2hpY2ggQUZBSUsgd2VyZSBub3QgcmVzb2x2ZWQ6Cj4KPiAxLiBTaGFkb3cgVk1D
UyBidWcsIHdoaWNoIGlzIGFsc28gYSB0ZXN0IGJ1ZyBbMV0uIFlvdSBjYW4gc3RhcnQgYnkgZml4
aW5nCj4gICAgdGhlIHRlc3QgYW5kIHRoZW4gZml4IEtWTS4KPgo+IDIuIFRyeSB0byBydW4gdGhl
IHRlc3RzIHdpdGggbW9yZSB0aGFuIDRHQiBvZiBtZW1vcnkuIFRoZSBsYXN0IHRpbWUgSSB0cmll
ZAo+ICAgIChhY3R1YWxseSBieSBydW5uaW5nIHRoZSB0ZXN0IG9uIGJhcmUgbWV0YWwpLCB0aGUg
SU5JVCB0ZXN0IHRoYXQgTGlyYW4KPiAgICB3cm90ZSBmYWlsZWQuCj4KPiBSZWdhcmRzLAo+IE5h
ZGF2Cj4KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzMyMzVEQkIwLTBEQzAtNDE4
Qy1CQzQ1LUE0Qjc4NjEyRTI3M0BnbWFpbC5jb20vVC8jdQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K

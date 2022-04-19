Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0C8C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 02:42:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0E740BA9;
	Mon, 18 Apr 2022 22:42:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TV-CoRtPV4mP; Mon, 18 Apr 2022 22:42:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D00B4B091;
	Mon, 18 Apr 2022 22:42:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA26449F1B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:42:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zag+oXhtemcY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2022 22:42:43 -0400 (EDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76F5A40BA9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:42:43 -0400 (EDT)
Received: by mail-wr1-f54.google.com with SMTP id g18so20542616wrb.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 19:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=NaZKghXfb3DoOx4eVJC6+gBDrMqsAj++iAp6qrZ51XE=;
 b=IOIawwuxeBpnPEW4muE+XmTP8tzJk+lOOZEPTVzGnnqkLERhpykUDERNuCeJW3dVWg
 F2fDXw4eW11ZRZ5O9TthYSN0mD67aAmgu8DVvp2E9JLQVJqa1jgm9s4vfF5w9amWFiWr
 s6v5e19V488KeCa61wXdMxsctCCtoRmaenKJKaPPlloMlSrxMXlwzDzmYDtQY5C2YsxM
 4lW/gEU1+nWPyqqg0ks5HwcAeQj/MpcAdfDy4UUFPpvKuahhdYdPjab3mvGFWVEMK0ne
 kAKhEeDMA20ZxRhIwrufTTknIPRk3Qf+MDIXPC46uwTSUxq7HP/4e023CZey2PT8PFSp
 iLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=NaZKghXfb3DoOx4eVJC6+gBDrMqsAj++iAp6qrZ51XE=;
 b=7RPxHBJoh0J3v/2xbuMshIl+ho0+6lw9MhCCr0RgS8Tup3w8HblYT5NpPMaTA/ApMX
 VQvtOGHpMMDAqcWVOoOYobyT23bdQ6GszXoSRcLF5z40/2gZ2pfFkeIwoKWlxbqg9B/K
 PPB/a+hgjUUeEK2l99HCHONklxZLlrBtc8MdcZmwHzBaBZ/HDuuv9CmItmSTZTed1RGu
 XKGu37JuJxL6FVstVUm8FSITSfIj9lSjv9Kl++6jH6SFWdGeDFsWTaVVPRwjvlga2LQS
 gPuz1eMVQkP4f6GhZs5VuVXHmubj1qfORAM0Fu6EsnNb+i27lIpUR/NEAI/WxWDLl70Z
 VWrQ==
X-Gm-Message-State: AOAM531X025q5EVLPUDBUEwL6qnxTtEmZgBVnIKMV7oayTSq4amy9Qxn
 Y+sNvS6GexQ8mIbx5bH0TfRPg4cNClzUN7TwoWfneA==
X-Google-Smtp-Source: ABdhPJwlJs4gJ4Ap7DqcjRwmKIBky5cw2JqOihJw3PpLKISM9MLa1vtSULvwejGmcmEXeoX04fS0XL9k/bB0wj9zdrM=
X-Received: by 2002:a5d:5487:0:b0:20a:8f45:8f34 with SMTP id
 h7-20020a5d5487000000b0020a8f458f34mr7573081wrv.699.1650336162246; Mon, 18
 Apr 2022 19:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
 <20220408200349.1529080-7-kaleshsingh@google.com>
 <87tuaqae7h.wl-maz@kernel.org>
In-Reply-To: <87tuaqae7h.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Apr 2022 19:42:31 -0700
Message-ID: <CAC_TJvfZD0KAM9z3+GEpNDJxanePuq+xFgauaMyYabGhPPuvQA@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] KVM: arm64: Symbolize the nVHE HYP addresses
To: Marc Zyngier <maz@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
 Andrew Walbran <qwandor@google.com>, Will Deacon <will@kernel.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Masahiro Yamada <masahiroy@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, Nathan Chancellor <nathan@kernel.org>,
 Changbin Du <changbin.du@intel.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>
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

T24gTW9uLCBBcHIgMTgsIDIwMjIgYXQgMzoxNiBBTSBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwu
b3JnPiB3cm90ZToKPgo+IE9uIEZyaSwgMDggQXByIDIwMjIgMjE6MDM6MjkgKzAxMDAsCj4gS2Fs
ZXNoIFNpbmdoIDxrYWxlc2hzaW5naEBnb29nbGUuY29tPiB3cm90ZToKPiA+Cj4gPiBSZWludHJv
ZHVjZSB0aGUgX19rdm1fbnZoZV8gc3ltYm9scyBpbiBrYWxsc3ltcywgaWdub3JpbmcgdGhlIGxv
Y2FsCj4gPiBzeW1ib2xzIGluIHRoaXMgbmFtZXNwYWNlLiBUaGUgbG9jYWwgc3ltYm9scyBhcmUg
bm90IGluZm9ybWF0aXZlIGFuZAo+ID4gY2FuIGNhdXNlIGFsaWFzaW5nIGlzc3VlcyB3aGVuIHN5
bWJvbGl6aW5nIHRoZSBhZGRyZXNzZXMuCj4gPgo+ID4gV2l0aCB0aGUgbmVjZXNzYXJ5IHN5bWJv
bHMgbm93IGluIGthbGxzeW1zIHdlIGNhbiBzeW1ib2xpemUgblZIRQo+ID4gYWRkcmVzc2VzIHVz
aW5nIHRoZSAlcCBwcmludCBmb3JtYXQgc3BlY2lmaWVyOgo+ID4KPiA+IFsgICA5OC45MTY0NDRd
WyAgVDQyNl0ga3ZtIFs0MjZdOiBuVkhFIGh5cCBwYW5pYyBhdDogWzxmZmZmZmZjMDA5NjE1NmZj
Pl0gX19rdm1fbnZoZV9vdmVyZmxvd19zdGFjaysweDgvMHgzNCEKPiA+Cj4gPiBTaWduZWQtb2Zm
LWJ5OiBLYWxlc2ggU2luZ2ggPGthbGVzaHNpbmdoQGdvb2dsZS5jb20+Cj4gPiBUZXN0ZWQtYnk6
IEZ1YWQgVGFiYmEgPHRhYmJhQGdvb2dsZS5jb20+Cj4gPiBSZXZpZXdlZC1ieTogRnVhZCBUYWJi
YSA8dGFiYmFAZ29vZ2xlLmNvbT4KPiA+IC0tLQo+ID4KPiA+IENoYW5nZXMgaW4gdjY6Cj4gPiAg
IC0gQWRkIEZ1YWQncyBSZXZpZXdlZC1ieSBhbmQgVGVzdGVkLWJ5IHRhZ3MuCj4gPgo+ID4gQ2hh
bmdlcyBpbiB2MjoKPiA+ICAgLSBGaXggcHJpbnRrIHdhcm5pbmdzIC0gJXAgZXhwZWN0cyAodm9p
ZCAqKQo+ID4KPiA+Cj4gPiAgYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYyB8IDEzICsrKysr
LS0tLS0tLS0KPiA+ICBzY3JpcHRzL2thbGxzeW1zLmMgICAgICAgICAgIHwgIDIgKy0KPiA+ICAy
IGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKPiA+Cj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYyBiL2FyY2gvYXJtNjQva3Zt
L2hhbmRsZV9leGl0LmMKPiA+IGluZGV4IDk3ZmUxNGFhYjFhMy4uYTM3N2I4NzFiZjU4IDEwMDY0
NAo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYwo+ID4gKysrIGIvYXJjaC9h
cm02NC9rdm0vaGFuZGxlX2V4aXQuYwo+ID4gQEAgLTI5NSwxMyArMjk1LDggQEAgdm9pZCBfX25v
cmV0dXJuIF9fY29sZCBudmhlX2h5cF9wYW5pY19oYW5kbGVyKHU2NCBlc3IsIHU2NCBzcHNyLAo+
ID4gICAgICAgdTY0IGVscl9pbl9raW1nID0gX19waHlzX3RvX2tpbWcoZWxyX3BoeXMpOwo+ID4g
ICAgICAgdTY0IGh5cF9vZmZzZXQgPSBlbHJfaW5fa2ltZyAtIGthc2xyX29mZnNldCgpIC0gZWxy
X3ZpcnQ7Cj4gPiAgICAgICB1NjQgbW9kZSA9IHNwc3IgJiBQU1JfTU9ERV9NQVNLOwo+ID4gKyAg
ICAgdTY0IHBhbmljX2FkZHIgPSBlbHJfdmlydCArIGh5cF9vZmZzZXQ7Cj4gPgo+ID4gLSAgICAg
LyoKPiA+IC0gICAgICAqIFRoZSBuVkhFIGh5cCBzeW1ib2xzIGFyZSBub3QgaW5jbHVkZWQgYnkg
a2FsbHN5bXMgdG8gYXZvaWQgaXNzdWVzCj4gPiAtICAgICAgKiB3aXRoIGFsaWFzaW5nLiBUaGF0
IG1lYW5zIHRoYXQgdGhlIHN5bWJvbHMgY2Fubm90IGJlIHByaW50ZWQgd2l0aCB0aGUKPiA+IC0g
ICAgICAqICIlcFMiIGZvcm1hdCBzcGVjaWZpZXIsIHNvIGZhbGwgYmFjayB0byB0aGUgdm1saW51
eCBhZGRyZXNzIGlmCj4gPiAtICAgICAgKiB0aGVyZSdzIG5vIGJldHRlciBvcHRpb24uCj4gPiAt
ICAgICAgKi8KPiA+ICAgICAgIGlmIChtb2RlICE9IFBTUl9NT0RFX0VMMnQgJiYgbW9kZSAhPSBQ
U1JfTU9ERV9FTDJoKSB7Cj4gPiAgICAgICAgICAgICAgIGt2bV9lcnIoIkludmFsaWQgaG9zdCBl
eGNlcHRpb24gdG8gblZIRSBoeXAhXG4iKTsKPiA+ICAgICAgIH0gZWxzZSBpZiAoRVNSX0VMeF9F
Qyhlc3IpID09IEVTUl9FTHhfRUNfQlJLNjQgJiYKPiA+IEBAIC0zMjEsOSArMzE2LDExIEBAIHZv
aWQgX19ub3JldHVybiBfX2NvbGQgbnZoZV9oeXBfcGFuaWNfaGFuZGxlcih1NjQgZXNyLCB1NjQg
c3BzciwKPiA+ICAgICAgICAgICAgICAgaWYgKGZpbGUpCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAga3ZtX2VycigiblZIRSBoeXAgQlVHIGF0OiAlczoldSFcbiIsIGZpbGUsIGxpbmUpOwo+ID4g
ICAgICAgICAgICAgICBlbHNlCj4gPiAtICAgICAgICAgICAgICAgICAgICAga3ZtX2VycigiblZI
RSBoeXAgQlVHIGF0OiAlMDE2bGx4IVxuIiwgZWxyX3ZpcnQgKyBoeXBfb2Zmc2V0KTsKPiA+ICsg
ICAgICAgICAgICAgICAgICAgICBrdm1fZXJyKCJuVkhFIGh5cCBCVUcgYXQ6IFs8JTAxNmxseD5d
ICVwQiFcbiIsIHBhbmljX2FkZHIsCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICh2b2lkICopcGFuaWNfYWRkcik7Cj4gPiAgICAgICB9IGVsc2Ugewo+ID4gLSAgICAg
ICAgICAgICBrdm1fZXJyKCJuVkhFIGh5cCBwYW5pYyBhdDogJTAxNmxseCFcbiIsIGVscl92aXJ0
ICsgaHlwX29mZnNldCk7Cj4gPiArICAgICAgICAgICAgIGt2bV9lcnIoIm5WSEUgaHlwIHBhbmlj
IGF0OiBbPCUwMTZsbHg+XSAlcEIhXG4iLCBwYW5pY19hZGRyLAo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKHZvaWQgKilwYW5pY19hZGRyKTsKPiA+ICAgICAgIH0KPiA+Cj4gPiAg
ICAgICAvKgo+ID4gZGlmZiAtLWdpdCBhL3NjcmlwdHMva2FsbHN5bXMuYyBiL3NjcmlwdHMva2Fs
bHN5bXMuYwo+ID4gaW5kZXggOGNhYWJkZGY4MTdjLi5hZDJjOTM2NDBhOTIgMTAwNjQ0Cj4gPiAt
LS0gYS9zY3JpcHRzL2thbGxzeW1zLmMKPiA+ICsrKyBiL3NjcmlwdHMva2FsbHN5bXMuYwo+ID4g
QEAgLTExMSw3ICsxMTEsNyBAQCBzdGF0aWMgYm9vbCBpc19pZ25vcmVkX3N5bWJvbChjb25zdCBj
aGFyICpuYW1lLCBjaGFyIHR5cGUpCj4gPiAgICAgICAgICAgICAgICIuTCIsICAgICAgICAgICAg
ICAgICAgIC8qIGxvY2FsIGxhYmVscywgLkxCQiwuTHRtcHh4eCwuTF9fdW5uYW1lZF94eCwuTEFT
QU5QQywgZXRjLiAqLwo+ID4gICAgICAgICAgICAgICAiX19jcmNfIiwgICAgICAgICAgICAgICAv
KiBtb2R2ZXJzaW9ucyAqLwo+ID4gICAgICAgICAgICAgICAiX19lZmlzdHViXyIsICAgICAgICAg
ICAvKiBhcm02NCBFRkkgc3R1YiBuYW1lc3BhY2UgKi8KPiA+IC0gICAgICAgICAgICAgIl9fa3Zt
X252aGVfIiwgICAgICAgICAgLyogYXJtNjQgbm9uLVZIRSBLVk0gbmFtZXNwYWNlICovCj4gPiAr
ICAgICAgICAgICAgICJfX2t2bV9udmhlXyQiLCAgICAgICAgIC8qIGFybTY0IGxvY2FsIHN5bWJv
bHMgaW4gbm9uLVZIRSBLVk0gbmFtZXNwYWNlICovCj4gPiAgICAgICAgICAgICAgICJfX0FBcmNo
NjRBRFJQVGh1bmtfIiwgIC8qIGFybTY0IGxsZCAqLwo+ID4gICAgICAgICAgICAgICAiX19BUk1W
NVBJTG9uZ1RodW5rXyIsICAvKiBhcm0gbGxkICovCj4gPiAgICAgICAgICAgICAgICJfX0FSTVY3
UElMb25nVGh1bmtfIiwKPgo+IElmIHlvdSBhcmUgc2FuaXRpc2luZyB0aGlzLCBzaG91bGRuJ3R0
IHlvdSBhbHNvIGFwcGx5IHRoZSBzYW1lIHJ1bGVzCj4gYXMgdGhlIHJlc3Qgb2YgdGhlIGtlcm5l
bCBmb3Igbm9uLSdfXy1rdm1fbnZoZV8nIHN5bWJvbHM/IEZvciBleGFtcGxlLAo+IEkgc2VlIGEg
bG9uZyBsaXN0IG9mIC5MKiBzeW1ib2xzOgo+Cj4gMDAwMDAwMDAwMDAwMDAwMCByIF9fa3ZtX252
aGVfLkwxNDQ3MjEKPiAwMDAwMDAwMDAwMDAwMDkwIHIgX19rdm1fbnZoZV8uTDE0NDcyMQo+IDAw
MDAwMDAwMDAwMDAwYjQgciBfX2t2bV9udmhlXy5MMTQ0NzIxCj4gMDAwMDAwMDAwMDAwMDRiMCBy
IF9fa3ZtX252aGVfLkwxNDQ3MjEKPiAwMDAwMDAwMDAwMDAwNTFjIHIgX19rdm1fbnZoZV8uTDE0
NDcyMQo+IDAwMDAwMDAwMDAwMDA2NTAgciBfX2t2bV9udmhlXy5MMTQ0NzIxCj4gMDAwMDAwMDAw
MDAwMDY5NCByIF9fa3ZtX252aGVfLkwxNDQ3MjEKPiAwMDAwMDAwMDAwMDAwNzYxIHIgX19rdm1f
bnZoZV8uTDE0NDcyMQo+IDAwMDAwMDAwMDAwMDA3YTcgciBfX2t2bV9udmhlXy5MMTQ0NzIxCj4g
MDAwMDAwMDAwMDAwMDdjNyByIF9fa3ZtX252aGVfLkwxNDQ3MjEKPiAwMDAwMDAwMDAwMDAwODE0
IHIgX19rdm1fbnZoZV8uTDE0NDcyMQo+IDAwMDAwMDAwMDAwMDBiMDggciBfX2t2bV9udmhlXy5M
MTQ0NzIxCj4gMDAwMDAwMDAwMDAwMzIwMCByIF9fa3ZtX252aGVfLkwxNDQ3MjEKPgo+ICg4MyBv
ZiB0aGVtIGluIHRvdGFsIG9uIGEgbG9jYWwgYnVpbGQpIHRoYXQgSSB0aGluayBzaG91bGQgYWxz
byBiZQo+IHRyaW1tZWQuCgpHb29kIGNhdGNoLiBJ4oCZbGwgZml4IGl0IGluIHRoZSBuZXh0IHZl
cnNpb24gYWxvbmcgd2l0aCB5b3VyIG90aGVyCmNvbW1lbnRzLiBUaGFua3MgZm9yIHRoZSByZXZp
ZXdzIE1hcmsuCgotS2FsZXNoCgo+Cj4gVGhhbmtzLAo+Cj4gICAgICAgICBNLgo+Cj4gLS0KPiBX
aXRob3V0IGRldmlhdGlvbiBmcm9tIHRoZSBub3JtLCBwcm9ncmVzcyBpcyBub3QgcG9zc2libGUu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

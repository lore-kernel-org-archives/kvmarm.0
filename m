Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18768C4321E
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 13:43:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7139540443;
	Mon,  5 Dec 2022 08:43:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6br0gXoF4OFN; Mon,  5 Dec 2022 08:43:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B5D40AEB;
	Mon,  5 Dec 2022 08:43:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7071540AEB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 08:43:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sm+yIMtELDcg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 08:43:14 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A620C40443
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 08:43:14 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id h11so18589845wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Dec 2022 05:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=PSfDwZPeG8ibIdq5sbKvkL1VsqUlUscnguEB5oSOxSc=;
 b=ZhFQOk5sHEFKzbm8fBjTNTecUMb6srGFq09hOHXW6kISqLW8gBDE3jNN0izPXaaE3X
 DVOXi2YDNUqfzOv8xB3pFAgcYIuK1FmRV4esx3+KJ3cyZFEiVKFzu7NPXpA2+JEoADaD
 13amI67POzIZYrUkAoNZH8B4OE4iZiDvYqvAJYQnER8FK5PwsZr6ShoWEvnTLGky3x/A
 HhQd1huG4wKL1p1O37IhT2z73k7GLly9/OUH08rQU99hjNPkV9UzyOOqX2HNMEd3rXei
 1tFaqBk4u8sgKKmkYUA8ncwGRbe6Jl7fYsJpJVyDCV6HGhhlyfUEgS5LpfZztLytNEiy
 wlog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:references:cc:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=PSfDwZPeG8ibIdq5sbKvkL1VsqUlUscnguEB5oSOxSc=;
 b=nEBEG5q4J6ayw9ijeBAPPsldW5n7z2uO54b4YR5LnhmA0FK8OvOt5icit8pf/RTBZ/
 LZIj3OJy/r2Wn8Y+nRTGWvusCKAe/uDNvvvO8m2gn6NyyK7a3HhYVWm908pFavBJksNR
 7sfspNSVnFHD3ammu5rz266TIJSYjIDMHyXaQz6DftQzwhe4f0+hP8wvaPC1mvbgJE/h
 /9INlrkZmbSh4U/dFRe2ug/wxL2nFNuBWYdAvuAVwSEzMht3HMaMte3rLpmfoIsc1oGw
 j8q3iCqrO1ckz3jny9a6dIsjXqtn/JoOVebeRAiZWawevZoJ/3F0tFyHUKz4scr192Lr
 gF1Q==
X-Gm-Message-State: ANoB5pnCdlhzwQeK2F+d2JycgrX3R7r1CZMndRv2nqaUfiQcZM14n1hG
 C5M/HDxcMVuLctS3C+Lsxutrkg==
X-Google-Smtp-Source: AA0mqf68CFsZMOCd88AhAlMizn4w9UrnERv3KIachtaDvBlHTCAHLOEwLF5Gb8KkdqSMJF8Id58Pag==
X-Received: by 2002:a5d:6e8e:0:b0:236:5e77:b58e with SMTP id
 k14-20020a5d6e8e000000b002365e77b58emr44809235wrz.320.1670247793408; 
 Mon, 05 Dec 2022 05:43:13 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4bd:0:4759:d90c:43ca:e8f0?
 ([2a02:6b6a:b4bd:0:4759:d90c:43ca:e8f0])
 by smtp.gmail.com with ESMTPSA id
 n3-20020a05600c3b8300b003cfbbd54178sm28603622wms.2.2022.12.05.05.43.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Dec 2022 05:43:12 -0800 (PST)
Message-ID: <66bc7368-aabc-9ec3-f4ba-a3bbeed5938b@bytedance.com>
Date: Mon, 5 Dec 2022 13:43:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted
 check
Content-Language: en-US
From: Usama Arif <usama.arif@bytedance.com>
To: Marc Zyngier <maz@kernel.org>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <87k048f3cm.wl-maz@kernel.org>
 <180b91af-a2aa-2cfd-eb7f-b2825c4e3dbe@bytedance.com>
 <86r0y1nmep.wl-maz@kernel.org>
 <95efd030-27f6-5668-a25e-9fbf210bfa1c@bytedance.com>
In-Reply-To: <95efd030-27f6-5668-a25e-9fbf210bfa1c@bytedance.com>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 bagasdotme@gmail.com, fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
 linux@armlinux.org.uk, liangma@liangbit.com, steven.price@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiAyNC8xMS8yMDIyIDEzOjU1LCBVc2FtYSBBcmlmIHdyb3RlOgo+IAo+IAo+IE9uIDE4LzEx
LzIwMjIgMDA6MjAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gTW9uLCAwNyBOb3YgMjAyMiAx
MjowMDo0NCArMDAwMCwKPj4gVXNhbWEgQXJpZiA8dXNhbWEuYXJpZkBieXRlZGFuY2UuY29tPiB3
cm90ZToKPj4+Cj4+Pgo+Pj4KPj4+IE9uIDA2LzExLzIwMjIgMTY6MzUsIE1hcmMgWnluZ2llciB3
cm90ZToKPj4+PiBPbiBGcmksIDA0IE5vdiAyMDIyIDA2OjIwOjU5ICswMDAwLAo+Pj4+IFVzYW1h
IEFyaWYgPHVzYW1hLmFyaWZAYnl0ZWRhbmNlLmNvbT4gd3JvdGU6Cj4+Pj4+Cj4+Pj4+IFRoaXMg
cGF0Y2hzZXQgYWRkcyBzdXBwb3J0IGZvciB2Y3B1X2lzX3ByZWVtcHRlZCBpbiBhcm02NCwgd2hp
Y2gKPj4+Pj4gYWxsb3dzIHRoZSBndWVzdCB0byBjaGVjayBpZiBhIHZjcHUgd2FzIHNjaGVkdWxl
ZCBvdXQsIHdoaWNoIGlzCj4+Pj4+IHVzZWZ1bCB0byBrbm93IGluY2FzZSBpdCB3YXMgaG9sZGlu
ZyBhIGxvY2suIHZjcHVfaXNfcHJlZW1wdGVkIGNhbgo+Pj4+PiBiZSB1c2VkIHRvIGltcHJvdmUg
cGVyZm9ybWFuY2UgaW4gbG9ja2luZyAoc2VlIG93bmVyX29uX2NwdSB1c2FnZSBpbgo+Pj4+PiBt
dXRleF9zcGluX29uX293bmVyLCBtdXRleF9jYW5fc3Bpbl9vbl9vd25lciwgcnRtdXRleF9zcGlu
X29uX293bmVyCj4+Pj4+IGFuZCBvc3FfbG9jaykgYW5kIHNjaGVkdWxpbmcgKHNlZSBhdmFpbGFi
bGVfaWRsZV9jcHUgd2hpY2ggaXMgdXNlZAo+Pj4+PiBpbiBzZXZlcmFsIHBsYWNlcyBpbiBrZXJu
ZWwvc2NoZWQvZmFpci5jIGZvciBlLmcuIGluIHdha2VfYWZmaW5lIHRvCj4+Pj4+IGRldGVybWlu
ZSB3aGljaCBDUFUgY2FuIHJ1biBzb29uZXN0KToKPj4+Pgo+Pj4+IFsuLi5dCj4+Pj4KPj4+Pj4g
cHZjeSBzaG93cyBhIHNtYWxsZXIgb3ZlcmFsbCBpbXByb3ZlbWVudCAoNTAlKSBjb21wYXJlZCB0
bwo+Pj4+PiB2Y3B1X2lzX3ByZWVtcHRlZCAoMjc3JSkuwqAgSG9zdCBzaWRlIGZsYW1lZ3JhcGgg
YW5hbHlzaXMgc2hvd3MgdGhhdAo+Pj4+PiB+NjAlIG9mIHRoZSBob3N0IHRpbWUgd2hlbiB1c2lu
ZyBwdmN5IGlzIHNwZW50IGluIGt2bV9oYW5kbGVfd2Z4LAo+Pj4+PiBjb21wYXJlZCB3aXRoIH4x
LjUlIHdoZW4gdXNpbmcgdmNwdV9pc19wcmVlbXB0ZWQsIGhlbmNlCj4+Pj4+IHZjcHVfaXNfcHJl
ZW1wdGVkIHNob3dzIGEgbGFyZ2VyIGltcHJvdmVtZW50Lgo+Pj4+Cj4+Pj4gQW5kIGhhdmUgeW91
IHdvcmtlZCBvdXQgKndoeSogd2Ugc3BlbmQgc28gbXVjaCB0aW1lIGhhbmRsaW5nIFdGRT8KPj4+
Pgo+Pj4+IMKgwqDCoMKgTS4KPj4+Cj4+PiBJdHMgZnJvbSB0aGUgZm9sbG93aW5nIGNoYW5nZSBp
biBwdmN5IHBhdGNoc2V0Ogo+Pj4KPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oYW5k
bGVfZXhpdC5jIGIvYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYwo+Pj4gaW5kZXggZTc3OGVl
ZmNmMjE0Li45MTU2NDQ4MTZhODUgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9oYW5k
bGVfZXhpdC5jCj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9oYW5kbGVfZXhpdC5jCj4+PiBAQCAt
MTE4LDcgKzExOCwxMiBAQCBzdGF0aWMgaW50IGt2bV9oYW5kbGVfd2Z4KHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkKPj4+IMKgwqDCoMKgwqDCoMKgwqAgfQo+Pj4KPj4+IMKgwqDCoMKgwqDCoMKgwqAg
aWYgKGVzciAmIEVTUl9FTHhfV0Z4X0lTU19XRkUpIHsKPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGt2bV92Y3B1X29uX3NwaW4odmNwdSwgdmNwdV9tb2RlX3ByaXYodmNwdSkpOwo+
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHN0YXRlOwo+Pj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgd2hpbGUgKChzdGF0ZSA9IGt2bV9wdmN5X2NoZWNrX3N0YXRl
KHZjcHUpKSA9PSAwKQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHNjaGVkdWxlKCk7Cj4+PiArCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpZiAoc3RhdGUgPT0gLTEpCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAga3ZtX3ZjcHVfb25fc3Bpbih2Y3B1LCB2Y3B1X21vZGVfcHJpdih2Y3B1KSk7
Cj4+PiDCoMKgwqDCoMKgwqDCoMKgIH0gZWxzZSB7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBpZiAoZXNyICYgRVNSX0VMeF9XRnhfSVNTX1dGeFQpCj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmNwdV9zZXRfZmxhZyh2Y3B1
LCBJTl9XRklUKTsKPj4+Cj4+Pgo+Pj4gSWYgbXkgdW5kZXJzdGFuZGluZyBpcyBjb3JyZWN0IG9m
IHRoZSBwdmN5IGNoYW5nZXMsIHdoZW5ldmVyIHB2Y3kKPj4+IHJldHVybnMgYW4gdW5jaGFuZ2Vk
IHZjcHUgc3RhdGUsIHdlIHdvdWxkIHNjaGVkdWxlIHRvIGFub3RoZXIKPj4+IHZjcHUuIEFuZCBp
dHMgdGhlIGNvbnN0YW50IHNjaGVkdWxpbmcgd2hlcmUgdGhlIHRpbWUgaXMgc3BlbnQuIEkgZ3Vl
c3MKPj4+IHRoZSBhZmZlY3RzIGFyZSBtdWNoIGhpZ2hlciB3aGVuIHRoZSBsb2NrIGNvbnRlbnRp
b24gaXMgdmVyeQo+Pj4gaGlnaC4gVGhpcyBjYW4gYmUgc2VlbSBmcm9tIHRoZSBwdmN5IGhvc3Qg
c2lkZSBmbGFtZWdyYXBoIGFzIHdlbGwgd2l0aAo+Pj4gKH42NyUgb2YgdGhlIHRpbWUgc3BlbnQg
aW4gdGhlIHNjaGVkdWxlKCkgY2FsbCBpbiBrdm1faGFuZGxlX3dmeCksIEZvcgo+Pj4gcmVmZXJl
bmNlLCBJIGhhdmUgcHV0IHRoZSBncmFwaCBhdDoKPj4+IGh0dHBzOi8vdWFyaWYxLmdpdGh1Yi5p
by9wdmxvY2svcGVyZl9ob3N0X3B2Y3lfbm1pLnN2Zwo+Pgo+PiBUaGUgcmVhbCBpc3N1ZSBoZXJl
IGlzIHRoYXQgd2UgZG9uJ3QgdHJ5IHRvIHBpY2sgdGhlIHJpZ2h0IHZjcHUgdG8KPj4gcnVuLCBh
bmQgc3RyaWN0bHkgcmVseSBvbiBzY2hlZHVsZSgpIHRvIGV2ZW50dWFsbHkgcGljayBzb21ldGhp
bmcgdGhhdAo+PiBjYW4gcnVuLgo+Pgo+PiBBbiBpbnRlcmVzdGluZyB0byBkbyB3b3VsZCBiZSB0
byB0cnkgYW5kIGZpdCB0aGUgZGlyZWN0ZWQgeWllbGQKPj4gbWVjaGFuaXNtIHRoZXJlLiBJdCB3
b3VsZCBiZSBhIGxvdCBtb3JlIGludGVyZXN0aW5nIHRoYW4gdGhlIG9uZS1vZmYKPj4gdmNwdV9p
c19wcmVlbXB0ZWQgaGFjaywgYXMgaXQgZ2l2ZXMgdXMgYSBsb3ctbGV2ZWwgcHJpbWl0aXZlIG9u
IHdoaWNoCj4+IHRvIGNvbnN0cnVjdCB0aGluZ3MgKHB2Y3kgaXMgZWZmZWN0aXZlbHkgYSBtd2Fp
dC1saWtlIHByaW1pdGl2ZSkuCj4gCj4gV2UgY291bGQgdXNlIGt2bV92Y3B1X3lpZWxkX3RvIHRv
IHlpZWxkIHRvIGEgc3BlY2lmaWMgdmNwdSwgYnV0IGhvdyAKPiB3b3VsZCB3ZSBkZXRlcm1pbmUg
d2hpY2ggdmNwdSB0byB5aWVsZCB0bz8KPiAKPiBJTU8gdmNwdV9pc19wcmVlbXB0ZWQgaXMgdmVy
eSB3ZWxsIGludGVncmF0ZWQgaW4gYSBsb3Qgb2YgY29yZSBrZXJuZWwgCj4gY29kZSwgaS5lLiBt
dXRleCwgcnRtdXRleCwgcndzZW0gYW5kIG9zcV9sb2NrLiBJdCBpcyBhbHNvIHVzZWQgaW4gCj4g
c2NoZWR1bGVyIHRvIGRldGVybWluZSBiZXR0ZXIgd2hpY2ggdkNQVSB3ZSBjYW4gcnVuIG9uIHNv
b25lc3QsIHNlbGVjdCAKPiBpZGxlIGNvcmUsIGV0Yy4gSSBhbSBub3Qgc3VyZSBpZiBhbGwgb2Yg
dGhlc2UgY2FzZXMgd2lsbCBiZSBvcHRpbWl6ZWQgYnkgCj4gcHZjeT8gQWxzbywgd2l0aCB2Y3B1
X2lzX3ByZWVtcHRlZCwgc29tZSBvZiB0aGUgbG9jayBoZWF2eSBiZW5jaG1hcmtzIAo+IGNvbWUg
ZG93biBmcm9tIHNwZW5kaW5nIGFyb3VuZCA1MCUgb2YgdGhlIHRpbWUgaW4gbG9jayB0byBsZXNz
IHRoYW4gMSUgCj4gKHNvIG5vdCBzdXJlIGhvdyBtdWNoIG1vcmUgcm9vbSBpcyB0aGVyZSBmb3Ig
aW1wcm92ZW1lbnQpLgo+IAo+IFdlIGNvdWxkIGFsc28gdXNlIHZjcHVfaXNfcHJlZW1wdGVkIHRv
IG9wdGltaXplIElQSSBwZXJmb3JtYW5jZSAoYWxvbmcgCj4gd2l0aCBkaXJlY3RlZCB5aWVsZCB0
byB0YXJnZXQgSVBJIHZDUFUpIHNpbWlsYXIgdG8gaG93IGl0cyBkb25lIGluIHg4NiAKPiAoaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzE1NjAyNTU4MzAtODY1Ni0yLWdpdC1zZW5kLWVtYWls
LXdhbnBlbmdsaUB0ZW5jZW50LmNvbS8pLiAKPiBUaGlzIGNhc2UgZGVmaW5pdGVseSB3b250IGJl
IGNvdmVyZWQgYnkgcHZjeS4KPiAKPiBDb25zaWRlcmluZyBhbGwgdGhlIGFib3ZlLCBpLmUuIHRo
ZSBjb3JlIGtlcm5lbCBpbnRlZ3JhdGlvbiBhbHJlYWR5IAo+IHByZXNlbnQgYW5kIHBvc3NpYmxl
IGZ1dHVyZSB1c2VjYXNlcyBvZiB2Y3B1X2lzX3ByZWVtcHRlZCwgbWF5YmUgaXRzIAo+IHdvcnRo
IG1ha2luZyB2Y3B1X2lzX3ByZWVtcHRlZCB3b3JrIG9uIGFybSBpbmRlcGVuZGVudGx5IG9mIHB2
Y3k/Cj4gCgpIaSwKCkp1c3Qgd2FudGVkIHRvIGNoZWNrIGlmIHRoZXJlIGFyZSBhbnkgY29tbWVu
dHMgb24gYWJvdmU/IEkgY2FuIHNlbmQgYSB2MyAKd2l0aCB0aGUgZG9jIGFuZCBjb2RlIGZpeGVz
IHN1Z2dlc3RlZCBpbiB0aGUgZWFybGllciByZXZpZXdzIGlmIGl0IG1ha2VzIApzZW5zZT8KClRo
YW5rcywKVXNhbWEKCj4gVGhhbmtzLAo+IFVzYW1hCj4gCj4+Cj4+IMKgwqDCoMKgTS4KPj4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

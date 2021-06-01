Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759B4C4708F
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 16:53:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0613613CD
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 16:53:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0613613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C0D4ACC9;
	Tue,  1 Jun 2021 12:53:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g0DPUkpHEsmo; Tue,  1 Jun 2021 12:53:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B814B089;
	Tue,  1 Jun 2021 12:53:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0065F4ACC9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 12:53:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E-kFBHZxs2SP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 12:52:59 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 426534A1AF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 12:52:59 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id m18so15076753wrv.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Jun 2021 09:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=IGzBwM/FiWo2cr+hWZs4nUI2Kv4IDMkVLM+9CQJF238=;
 b=f84PU//5+i1JJBE5ruUPfGARtqEU9CYtEYISnjRSi2nPrVVPe+fAoxZ/hpRKujnlp7
 /+Z3vT1r1jPfbQnrQs0nnVqibPWeSFOfE+X1+unu+nCypsNU/OLt+Frm5jiH06moh0MV
 kijMmz+IYg0DvRGw8COK5JYRUHEbhvsw1bL1NPL1nMptsEv5CRWLhaOmHsbk7axbP07z
 4s/+rpaS/SFHEAdcl5h2j0lvcBkntQ6oTFM+n02NDiZaqu3I3slCHVRBjz0LnCH/n8uu
 7T7a3rjyFCcNGcb5mj+QwZEVDOyNIalMnujxqZCaw+E4D2X2DcZTaS7kSYjly682MkyO
 gBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=IGzBwM/FiWo2cr+hWZs4nUI2Kv4IDMkVLM+9CQJF238=;
 b=Guve6ws9juuqiQdlGH9vlDTvjCCeIjzkjt03cTg/KSaVgOyA3QTPjx+AwsvqmEJX65
 n58ZgK9R6+0K6QkYFb6+Ztkfa7ij3cS/qMsloaIZq/gdEtQF+AiZ4iEKTByag7RxEXqL
 ld6ZQgJ1/pe3HI8QRxy5IbmnvaebWOEHfNXuO77Bbro9o+0w17c1hyXDPjY6QskbN6LK
 HUff4FCqKj25ZQlwe1e+JVPZ4WLQFlJJxsUPGtoclJgQ8vm0GjXAkhZLUwrb9dhnHqYd
 KFprKt9IA9kseXmswubpr6U9QYzKqq9gLy/paEtdagFXCCwk5FkAM834aF4TpnQb7tE4
 kpNg==
X-Gm-Message-State: AOAM530aerhtvJVx/OArnl6zUdwgy8YVuyW/1lMkvLDeYkhPYtB/PUtM
 jwGKzgDQKIe85Ka9V5AAVULKuA==
X-Google-Smtp-Source: ABdhPJyWAXSCWp2cOYZJu4DY5u1E3sAHtc56x2ckLQSmOXk1Juq85vX1VKdcBkXllQIaHBQqTsU4hQ==
X-Received: by 2002:adf:fe8c:: with SMTP id l12mr4046467wrr.26.1622566378074; 
 Tue, 01 Jun 2021 09:52:58 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id c64sm84851wma.15.2021.06.01.09.52.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Jun 2021 09:52:56 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 2D3831FF7E;
 Tue,  1 Jun 2021 17:52:56 +0100 (BST)
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-5-alex.bennee@linaro.org>
 <5fe1c796-c886-e5c6-6e61-e12d0f73a884@redhat.com>
User-agent: mu4e 1.5.13; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Date: Tue, 01 Jun 2021 17:49:01 +0100
In-reply-to: <5fe1c796-c886-e5c6-6e61-e12d0f73a884@redhat.com>
Message-ID: <87sg21bk7r.fsf@linaro.org>
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

CkF1Z2VyIEVyaWMgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4gd3JpdGVzOgoKPiBIaSBBbGV4LAo+
Cj4gT24gNS8yNS8yMSA3OjI2IFBNLCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4+IFdoZW4gcnVubmlu
ZyB0aGUgdGVzdCBpbiBUQ0cgd2UgYXJlIGJhc2ljYWxseSBydW5uaW5nIG9uIGJhcmUgbWV0YWwg
c28KPj4gZG9uJ3QgcmVseSBvbiBoYXZpbmcgYSBwYXJ0aWN1bGFyIGtlcm5lbCBlcnJhdGEgYXBw
bGllZC4KPj4gCj4+IFlvdSBtaWdodCB3b25kZXIgd2h5IHdlIGhhbmRsZSB0aGlzIHdpdGggYSB0
b3RhbGx5IG5ldyB0ZXN0IG5hbWUKPj4gaW5zdGVhZCBvZiBhZGp1c3RpbmcgdGhlIGFwcGVuZCB0
byB0YWtlIGFuIGV4dHJhIHBhcmFtZXRlcj8gV2VsbCB0aGUKPj4gcnVuX21pZ3JhdGlvbiBzaGVs
bCBzY3JpcHQgdXNlcyBldmFsICIkQCIgd2hpY2ggdW53cmFwcyB0aGUgLWFwcGVuZAo+PiBsZWFk
aW5nIHRvIGFueSBzZWNvbmQgcGFyYW1ldGVyIGJlaW5nIHNwbGl0IGFuZCBsZWF2aW5nIFFFTVUg
dmVyeQo+PiBjb25mdXNlZCBhbmQgdGhlIHRlc3QgaGFuZ2luZy4gVGhpcyBzZWVtZWQgc2ltcGxl
ciB0aGFuIHJlLXdyaXRpbmcgYWxsCj4+IHRoZSB0ZXN0IHJ1bm5pbmcgbG9naWMgaW4gc29tZXRo
aW5nIHNhbmUgOy0pCj4KPiB0aGVyZSBpcwo+IGxpYi9zMzkweC92bS5oOmJvb2wgdm1faXNfdGNn
KHZvaWQpCj4KPiBidXQgSSBkb24ndCBzZWUgYW55IHBhcnRpY3VsYXIgSUQgd2UgY291bGQgdXNl
IHRvIGRpZmZlcmVudGlhdGUgYm90aCB0aGUKPiBLVk0gYW5kIHRoZSBUQ0cgbW9kZSwgZG8geW91
PwoKRm9yIC1jcHUgbWF4IHdlIGRvOgoKICAgICAgICAvKgogICAgICAgICAqIFJlc2V0IE1JRFIg
c28gdGhlIGd1ZXN0IGRvZXNuJ3QgbWlzdGFrZSBvdXIgJ21heCcgQ1BVIHR5cGUgZm9yIGEgcmVh
bAogICAgICAgICAqIG9uZSBhbmQgdHJ5IHRvIGFwcGx5IGVycmF0YSB3b3JrYXJvdW5kcyBvciB1
c2UgaW1wZGVmIGZlYXR1cmVzIHdlCiAgICAgICAgICogZG9uJ3QgcHJvdmlkZS4KICAgICAgICAg
KiBBbiBJTVBMRU1FTlRFUiBmaWVsZCBvZiAwIG1lYW5zICJyZXNlcnZlZCBmb3Igc29mdHdhcmUg
dXNlIjsKICAgICAgICAgKiBBUkNISVRFQ1RVUkUgbXVzdCBiZSAweGYgaW5kaWNhdGluZyAidjcg
b3IgbGF0ZXIsIGNoZWNrIElEIHJlZ2lzdGVycwogICAgICAgICAqIHRvIHNlZSB3aGljaCBmZWF0
dXJlcyBhcmUgcHJlc2VudCI7CiAgICAgICAgICogdGhlIFZBUklBTlQsIFBBUlROVU0gYW5kIFJF
VklTSU9OIGZpZWxkcyBhcmUgYWxsIGltcGxlbWVudGF0aW9uCiAgICAgICAgICogZGVmaW5lZCBh
bmQgd2UgY2hvb3NlIHRvIGRlZmluZSBQQVJUTlVNIGp1c3QgaW4gY2FzZSBndWVzdAogICAgICAg
ICAqIGNvZGUgbmVlZHMgdG8gZGlzdGluZ3Vpc2ggdGhpcyBRRU1VIENQVSBmcm9tIG90aGVyIHNv
ZnR3YXJlCiAgICAgICAgICogaW1wbGVtZW50YXRpb25zLCB0aG91Z2ggdGhpcyBzaG91bGRuJ3Qg
YmUgbmVlZGVkLgogICAgICAgICAqLwogICAgICAgIHQgPSBGSUVMRF9EUDY0KDAsIE1JRFJfRUwx
LCBJTVBMRU1FTlRFUiwgMCk7CiAgICAgICAgdCA9IEZJRUxEX0RQNjQodCwgTUlEUl9FTDEsIEFS
Q0hJVEVDVFVSRSwgMHhmKTsKICAgICAgICB0ID0gRklFTERfRFA2NCh0LCBNSURSX0VMMSwgUEFS
VE5VTSwgJ1EnKTsKICAgICAgICB0ID0gRklFTERfRFA2NCh0LCBNSURSX0VMMSwgVkFSSUFOVCwg
MCk7CiAgICAgICAgdCA9IEZJRUxEX0RQNjQodCwgTUlEUl9FTDEsIFJFVklTSU9OLCAwKTsKICAg
ICAgICBjcHUtPm1pZHIgPSB0OwoKSG93ZXZlciBmb3IgdGhlIGRlZmF1bHQgLWNwdSBjb3J0ZXgt
YTU3IHdlIGFpbSB0byBsb29rIGp1c3QgbGlrZSB0aGUKcmVhbCB0aGluZyAtIG9ubHkgd2l0aG91
dCBhbnkgYW5ub3lpbmcgbWljcm8tYXJjaGl0ZWN0dXJlIGJ1Z3MgOy0pCgo+Cj4gd2l0aG91dCBh
IG1vcmUgZWxlZ2FudCBzb2x1dGlvbiwKCkknbGwgbG9vayBpbnRvIHRoZSBzdWdnZXN0aW9uIG1h
ZGUgYnkgUmljaGFyZC4KCj4gUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVk
aGF0LmNvbT4KPgo+IFRoYW5rcwo+Cj4gRXJpYwo+Cj4KPj4gCj4+IFNpZ25lZC1vZmYtYnk6IEFs
ZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPj4gQ2M6IFNoYXNoaSBNYWxsZWxh
IDxzaGFzaGkubWFsbGVsYUBsaW5hcm8ub3JnPgo+PiAtLS0KPj4gIGFybS9naWMuYyAgICAgICAg
IHwgIDggKysrKysrKy0KPj4gIGFybS91bml0dGVzdHMuY2ZnIHwgMTAgKysrKysrKysrLQo+PiAg
MiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+PiAKPj4g
ZGlmZiAtLWdpdCBhL2FybS9naWMuYyBiL2FybS9naWMuYwo+PiBpbmRleCBiZWYwNjFhLi4wZmNl
MmE0IDEwMDY0NAo+PiAtLS0gYS9hcm0vZ2ljLmMKPj4gKysrIGIvYXJtL2dpYy5jCj4+IEBAIC0z
Niw2ICszNiw3IEBAIHN0YXRpYyBzdHJ1Y3QgZ2ljICpnaWM7Cj4+ICBzdGF0aWMgaW50IGFja2Vk
W05SX0NQVVNdLCBzcHVyaW91c1tOUl9DUFVTXTsKPj4gIHN0YXRpYyBpbnQgaXJxX3NlbmRlcltO
Ul9DUFVTXSwgaXJxX251bWJlcltOUl9DUFVTXTsKPj4gIHN0YXRpYyBjcHVtYXNrX3QgcmVhZHk7
Cj4+ICtzdGF0aWMgYm9vbCB1bmRlcl90Y2c7Cj4+ICAKPj4gIHN0YXRpYyB2b2lkIG5yX2NwdV9j
aGVjayhpbnQgbnIpCj4+ICB7Cj4+IEBAIC04MzQsNyArODM1LDcgQEAgc3RhdGljIHZvaWQgdGVz
dF9taWdyYXRlX3VubWFwcGVkX2NvbGxlY3Rpb24odm9pZCkKPj4gIAkJZ290byBkb19taWdyYXRl
Owo+PiAgCX0KPj4gIAo+PiAtCWlmICghZXJyYXRhKEVSUkFUQV9VTk1BUFBFRF9DT0xMRUNUSU9O
UykpIHsKPj4gKwlpZiAoIWVycmF0YShFUlJBVEFfVU5NQVBQRURfQ09MTEVDVElPTlMpICYmICF1
bmRlcl90Y2cpIHsKPj4gIAkJcmVwb3J0X3NraXAoIlNraXBwaW5nIHRlc3QsIGFzIHRoaXMgdGVz
dCBoYW5ncyB3aXRob3V0IHRoZSBmaXguICIKPj4gIAkJCSAgICAiU2V0ICVzPXkgdG8gZW5hYmxl
LiIsIEVSUkFUQV9VTk1BUFBFRF9DT0xMRUNUSU9OUyk7Cj4+ICAJCXRlc3Rfc2tpcHBlZCA9IHRy
dWU7Cj4+IEBAIC0xMDA1LDYgKzEwMDYsMTEgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQo+PiAgCQlyZXBvcnRfcHJlZml4X3B1c2goYXJndlsxXSk7Cj4+ICAJCXRlc3RfbWlncmF0
ZV91bm1hcHBlZF9jb2xsZWN0aW9uKCk7Cj4+ICAJCXJlcG9ydF9wcmVmaXhfcG9wKCk7Cj4+ICsJ
fSBlbHNlIGlmICghc3RyY21wKGFyZ3ZbMV0sICJpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0
aW9uLXRjZyIpKSB7Cj4+ICsJCXVuZGVyX3RjZyA9IHRydWU7Cj4+ICsJCXJlcG9ydF9wcmVmaXhf
cHVzaChhcmd2WzFdKTsKPj4gKwkJdGVzdF9taWdyYXRlX3VubWFwcGVkX2NvbGxlY3Rpb24oKTsK
Pj4gKwkJcmVwb3J0X3ByZWZpeF9wb3AoKTsKPj4gIAl9IGVsc2UgaWYgKHN0cmNtcChhcmd2WzFd
LCAiaXRzLWludHJvc3BlY3Rpb24iKSA9PSAwKSB7Cj4+ICAJCXJlcG9ydF9wcmVmaXhfcHVzaChh
cmd2WzFdKTsKPj4gIAkJdGVzdF9pdHNfaW50cm9zcGVjdGlvbigpOwo+PiBkaWZmIC0tZ2l0IGEv
YXJtL3VuaXR0ZXN0cy5jZmcgYi9hcm0vdW5pdHRlc3RzLmNmZwo+PiBpbmRleCAxYTM5NDI4Li5h
ZGMxYmJmIDEwMDY0NAo+PiAtLS0gYS9hcm0vdW5pdHRlc3RzLmNmZwo+PiArKysgYi9hcm0vdW5p
dHRlc3RzLmNmZwo+PiBAQCAtMjA1LDcgKzIwNSw3IEBAIGV4dHJhX3BhcmFtcyA9IC1tYWNoaW5l
IGdpYy12ZXJzaW9uPTMgLWFwcGVuZCAnaXRzLXBlbmRpbmctbWlncmF0aW9uJwo+PiAgZ3JvdXBz
ID0gaXRzIG1pZ3JhdGlvbgo+PiAgYXJjaCA9IGFybTY0Cj4+ICAKPj4gLVtpdHMtbWlncmF0ZS11
bm1hcHBlZC1jb2xsZWN0aW9uXQo+PiArW2l0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24t
a3ZtXQo+PiAgZmlsZSA9IGdpYy5mbGF0Cj4+ICBzbXAgPSAkTUFYX1NNUAo+PiAgYWNjZWwgPSBr
dm0KPj4gQEAgLTIxMyw2ICsyMTMsMTQgQEAgZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZl
cnNpb249MyAtYXBwZW5kICdpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uJwo+PiAgZ3Jv
dXBzID0gaXRzIG1pZ3JhdGlvbgo+PiAgYXJjaCA9IGFybTY0Cj4+ICAKPj4gK1tpdHMtbWlncmF0
ZS11bm1hcHBlZC1jb2xsZWN0aW9uLXRjZ10KPj4gK2ZpbGUgPSBnaWMuZmxhdAo+PiArc21wID0g
JE1BWF9TTVAKPj4gK2FjY2VsID0gdGNnCj4+ICtleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMt
dmVyc2lvbj0zIC1hcHBlbmQgJ2l0cy1taWdyYXRlLXVubWFwcGVkLWNvbGxlY3Rpb24tdGNnJwo+
PiArZ3JvdXBzID0gaXRzIG1pZ3JhdGlvbgo+PiArYXJjaCA9IGFybTY0Cj4+ICsKPj4gICMgVGVz
dCBQU0NJIGVtdWxhdGlvbgo+PiAgW3BzY2ldCj4+ICBmaWxlID0gcHNjaS5mbGF0Cj4+IAoKCi0t
IApBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

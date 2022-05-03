Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEB4C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 18:49:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9724B18F;
	Tue,  3 May 2022 14:49:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FbKowe92JWek; Tue,  3 May 2022 14:49:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C8984B0DF;
	Tue,  3 May 2022 14:49:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B8349EF1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 14:49:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8pZX6BOd1bEl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 14:49:23 -0400 (EDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com
 [209.85.128.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7E624B086
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 14:49:23 -0400 (EDT)
Received: by mail-yw1-f176.google.com with SMTP id
 00721157ae682-2f7d621d1caso189672397b3.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 11:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=2RVFHg4J+XiYNHLd6mO9jBpgTMA8wJDRHLKt8HLDZag=;
 b=D8eHTcfTZf0aangD3/F507rAzlAJhrb5z3tZDy1kbX20PciK6IfBwz/4PNfuleSx0Q
 Q0xU7/YQtPzsLyeLgw1EAa1R8W73BCJmdkq5MMpFtJNdr6ZvwYyxjYSWDH3eTqNsXRMB
 tbCxbVWfMhpiKcj3/ASXTdhk5YNGZjKX6kOl5X4ZHYOs4V0Fa+ZbhGRjXdYgY/Erom7f
 kmCXngcb/dxpkWWMSzCaE7lFNfN+fVCBzvJ/rNdquW8eZvEpSpOqjnzlsDZ+HgIWJEnj
 vduTalPXsNoQB+nme19yLfsZu0p6LTEluDGahZfkayRKYiJqoVrjAQpWzOGig+3e8eto
 7PAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=2RVFHg4J+XiYNHLd6mO9jBpgTMA8wJDRHLKt8HLDZag=;
 b=UmdMntc98p/9um3OlnPm0+CB6hiwjHh514jC2ffnE/P8wa6hiajd6fDfPG/TRVOYnY
 XRXQRMIlBJXe6vNBxDwYxTf4uDi6yjdkq7xXDSU7jrpFZoKoi08wNpWPvlWwCEXf3UcM
 Cd8odXjA83fQWtfiv/ttV/1kji8xpD43sFxBi2jSaFcWmcci4kcJyfRqu6oCG+zq61qO
 iEP0AZU4hAl+1ne310PSY2tOuvZpbWZEP/i2mRkOuJyQkPIiS2ySiDp+8F0Lq3ygdw/3
 8rkuGtuzIFdqNcDPHfEeF0nFnGCyn6LQNJcj2AZ0E9hDqQXGZg+ML3Vo5l3SYgLnc4qM
 hZ8Q==
X-Gm-Message-State: AOAM5304Wxg6quX08z75rxzqBI3Mxq5LPPUjbc64mE7k8xIcTzK6HA4R
 UXpF33NTBSxDtScVthmsUgv4e/Lf0E+TjPrh5fjJgQ==
X-Google-Smtp-Source: ABdhPJwlC5LLT8qc2EBu/75ZFoBSCD2aheEv/0F0Bxd/JtnhVZiAZdUSCNlpn7PYi6ZP9gaCJKYUVW6yxjrPsLKdXKQ=
X-Received: by 2002:a0d:dd90:0:b0:2f8:5459:486e with SMTP id
 g138-20020a0ddd90000000b002f85459486emr16835296ywe.427.1651603763187; Tue, 03
 May 2022 11:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
 <878rri8r78.wl-maz@kernel.org>
In-Reply-To: <878rri8r78.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 3 May 2022 11:49:13 -0700
Message-ID: <CAJHc60xp=UQT_CX0zoiSjAmkS8JSe+NB5Gr+F5mmybjJAWkUtQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/9] KVM: arm64: Add support for hypercall services
 selection
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

SGkgTWFyYywKCk9uIFR1ZSwgTWF5IDMsIDIwMjIgYXQgMTA6MjQgQU0gTWFyYyBaeW5naWVyIDxt
YXpAa2VybmVsLm9yZz4gd3JvdGU6Cj4KPiBPbiBUdWUsIDAzIE1heSAyMDIyIDAwOjM4OjQ0ICsw
MTAwLAo+IFJhZ2hhdmVuZHJhIFJhbyBBbmFudGEgPHJhbmFudGFAZ29vZ2xlLmNvbT4gd3JvdGU6
Cj4gPgo+ID4gSGVsbG8sCj4gPgo+ID4gQ29udGludWluZyB0aGUgZGlzY3Vzc2lvbiBmcm9tIFsx
XSwgdGhlIHNlcmllcyB0cmllcyB0byBhZGQgc3VwcG9ydAo+ID4gZm9yIHRoZSB1c2Vyc3BhY2Ug
dG8gZWxlY3QgdGhlIGh5cGVyY2FsbCBzZXJ2aWNlcyB0aGF0IGl0IHdpc2hlcwo+ID4gdG8gZXhw
b3NlIHRvIHRoZSBndWVzdCwgcmF0aGVyIHRoYW4gdGhlIGd1ZXN0IGRpc2NvdmVyaW5nIHRoZW0K
PiA+IHVuY29uZGl0aW9uYWxseS4gVGhlIGlkZWEgZW1wbG95ZWQgYnkgdGhlIHNlcmllcyB3YXMg
dGFrZW4gZnJvbQo+ID4gWzFdIGFzIHN1Z2dlc3RlZCBieSBNYXJjIFouCj4KPiBBcyBpdCB0b29r
IHNvbWUgdGltZSB0byBnZXQgdGhlcmUsIGFuZCB0aGF0IHRoZXJlIHdhcyBzdGlsbCBhIGJ1bmNo
IG9mCj4gdGhpbmdzIHRvIGFkZHJlc3MsIEkndmUgdGFrZW4gdGhlIGxpYmVydHkgdG8gYXBwbHkg
bXkgb3duIGZpeGVzIHRvIHRoZQo+IHNlcmllcy4KPgo+IFBsZWFzZSBoYXZlIGEgbG9vayBhdCBb
MV0sIGFuZCBsZXQgbWUga25vdyBpZiB5b3UncmUgT0sgd2l0aCB0aGUKPiByZXN1bHQuIElmIHlv
dSBhcmUsIEknbGwgbWVyZ2UgdGhlIHNlcmllcyBmb3IgNS4xOS4KPgo+IFRoYW5rcywKPgo+ICAg
ICAgICAgTS4KPgpUaGFuayB5b3UgZm9yIHNwZWVkaW5nIHVwIHRoZSBwcm9jZXNzOyBhcHByZWNp
YXRlIGl0LiBIb3dldmVyLCB0aGUKc2VyaWVzJ3Mgc2VsZnRlc3QgcGF0Y2hlcyBoYXZlIGEgZGVw
ZW5kZW5jeSBvbiBPbGl2ZXIncwpQU0NJX1NZU1RFTV9TVVNQRU5EJ3Mgc2VsZnRlc3QgcGF0Y2hl
cyBbMV1bMl0uIENhbiB3ZSBwdWxsIHRoZW0gaW4KdG9vPwoKYWFyY2g2NC9oeXBlcmNhbGxzLmM6
IEluIGZ1bmN0aW9uIOKAmGd1ZXN0X3Rlc3RfaHZj4oCZOgphYXJjaDY0L2h5cGVyY2FsbHMuYzo5
NTozMDogZXJyb3I6IHN0b3JhZ2Ugc2l6ZSBvZiDigJhyZXPigJkgaXNu4oCZdCBrbm93bgogICA5
NSB8ICAgICAgICAgc3RydWN0IGFybV9zbWNjY19yZXMgcmVzOwogICAgICB8ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXn5+CmFhcmNoNjQvaHlwZXJjYWxscy5jOjEwMzoxNzogd2Fybmlu
ZzogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24K4oCYc21jY2NfaHZj4oCZIFstV2lt
cGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQogIDEwMyB8ICAgICAgICAgICAgICAgICBzbWNj
Y19odmMoaGNfaW5mby0+ZnVuY19pZCwgaGNfaW5mby0+YXJnMSwgMCwKMCwgMCwgMCwgMCwgMCwg
JnJlcyk7CiAgICAgIHwgICAgICAgICAgICAgICAgIF5+fn5+fn5+fgoKQWxzbywganVzdCBhIGNv
dXBsZSBvZiByZWFkYWJpbGl0eSBuaXRzIGluIHRoZSBmaXhlZCB2ZXJzaW9uOgoKMS4gUGF0Y2gt
Mi85LCBoeXBlcmNhbGwuYzprdm1faHZjX2NhbGxfZGVmYXVsdF9hbGxvd2VkKCksIGluIHRoZQon
ZGVmYXVsdCcgY2FzZSwgZG8geW91IHRoaW5rIHdlIHNob3VsZCBwcm9iYWJseSBhZGQgYSBzbWFs
bCBjb21tZW50CnRoYXQgbWVudGlvbnMgd2UgYXJlIGNoZWNraW5nIGZvciBmdW5jX2lkIGluIHRo
ZSBQU0NJIHJhbmdlPwoyLiBQYXRjaC0yLzksIGFybV9oeXBlcmNhbGwuaCwgY2xlYXIgYWxsIHRo
ZSBtYWNyb3MgaW4gdGhpcyBwYXRjaAppdHNlbGYgaW5zdGVhZCBvZiBkb2luZyBpdCBpbiBpbmNy
ZW1lbnRzICh1bmxlc3MgdGhlcmUncyBzb21lIHJlYXNvbgp0aGF0IEknbSBtaXNzaW5nKT8KClJl
Z2FyZHMsClJhZ2hhdmVuZHJhCgpbMV06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIy
MDQwOTE4NDU0OS4xNjgxMTg5LTEwLW91cHRvbkBnb29nbGUuY29tLwpbMl06IGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2FsbC8yMDIyMDQwOTE4NDU0OS4xNjgxMTg5LTExLW91cHRvbkBnb29nbGUu
Y29tLwoKPiBbMV0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvbWF6L2FybS1wbGF0Zm9ybXMuZ2l0L2xvZy8/aD1rdm0tYXJtNjQvaGNhbGwtc2VsZWN0aW9u
Cj4KPiAtLQo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dyZXNzIGlzIG5v
dCBwb3NzaWJsZS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

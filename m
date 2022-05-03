Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF05FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 21:09:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C7C44B139;
	Tue,  3 May 2022 17:09:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h26Q0K8lQ6qd; Tue,  3 May 2022 17:09:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA2E49EBE;
	Tue,  3 May 2022 17:09:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20EDE43479
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 17:09:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 73BnYa1JdQnt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 17:09:41 -0400 (EDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
 [209.85.219.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D00B4089A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 17:09:41 -0400 (EDT)
Received: by mail-yb1-f181.google.com with SMTP id y76so33282503ybe.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 14:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=4fiXOSargbkmqorI6WusV2qGhD3iqsqBH5PjRfunjuA=;
 b=YoNJVD72g3AVg+3aeTpK8KNgGmRrdH21U6jGrIF4yTt28emi7xJOvR/HVHHovuFaVi
 Rd+rn0a8n7qTEglfwFmqhABF0y3SYRRRrmknTwyamT3woWJY7QvpPos6aPXoaNRQJ2oV
 B2VptOYHCq2ctdiq3rOLXvB7cTCEBFxxlta1hd9rw1xOAdhwINOkLE7bA29UfIHpgFe1
 Hi91a1cNyIXPOEJMCLjMi/mGqk+JQ7EGfMXLspEaH/MUkinOK6Hl+zjrf4PxxZfQKJdc
 H7PHfoB0QvVbHEfxf1qjOczuwlVUt+tWhFVrhaqw0qsMVX2ApZ2DOZRrlXestDqBC8FU
 lZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=4fiXOSargbkmqorI6WusV2qGhD3iqsqBH5PjRfunjuA=;
 b=hi3rug1V93YIaV49hE8ubXJkO8HgbnHhnp3gIFKkzT3x+5VizivzSCNgueMFc1/N77
 JNQMhcPFFWdYeuYO+8UhvLDSRzPM+FnheYMAobflW2ULx5zN4iuGxbUdhW7l8UTQe0kB
 kQUTGOnMQ2QksRAbOjeqgfsNgI39EY9eNqNisk4E4TsjIWO2U/CtdN+X+5lc4H5ePg+V
 OzZCB3ErCWLyIuOEqKv/yQcBhv2KcS0NjffgQg7HAvtRj/zRDwgLUeVLgWoBWVPKKxxQ
 WOzUe6qJ+SvkE9bSwx37MAVpmbEpLBJVS1wlu4FH3vgF1VcnDU+S1p64s2FqXfZrcxnz
 v/6w==
X-Gm-Message-State: AOAM533fmUiLMOpeJvpXZVSdF+vQ/AJMMWm8bjFQAZFkxsocL5zYE0sx
 8cxjQOwuh5Evr/e+J7PdygGhj58oBfRfag88Pr2phQ==
X-Google-Smtp-Source: ABdhPJwbHPh4pTxe5Aps2H2tu8JbsnM+d6wHpFw0d/yrdwjO15HqS7ozkDExBWLCf3hEz5mOJ+dkfiEmK/8p91Cr1A4=
X-Received: by 2002:a25:b095:0:b0:649:d59e:4c07 with SMTP id
 f21-20020a25b095000000b00649d59e4c07mr5306279ybj.627.1651612180307; Tue, 03
 May 2022 14:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
 <878rri8r78.wl-maz@kernel.org>
 <CAJHc60xp=UQT_CX0zoiSjAmkS8JSe+NB5Gr+F5mmybjJAWkUtQ@mail.gmail.com>
 <878rriicez.wl-maz@kernel.org>
In-Reply-To: <878rriicez.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 3 May 2022 14:09:29 -0700
Message-ID: <CAJHc60w1F7RAgJkv5PRuJtKjTw1gUaYmZk885AVhPLF2h6YbkQ@mail.gmail.com>
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

T24gVHVlLCBNYXkgMywgMjAyMiBhdCAxOjMzIFBNIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+IHdyb3RlOgo+Cj4gT24gVHVlLCAwMyBNYXkgMjAyMiAxOTo0OToxMyArMDEwMCwKPiBSYWdo
YXZlbmRyYSBSYW8gQW5hbnRhIDxyYW5hbnRhQGdvb2dsZS5jb20+IHdyb3RlOgo+ID4KPiA+IEhp
IE1hcmMsCj4gPgo+ID4gT24gVHVlLCBNYXkgMywgMjAyMiBhdCAxMDoyNCBBTSBNYXJjIFp5bmdp
ZXIgPG1hekBrZXJuZWwub3JnPiB3cm90ZToKPiA+ID4KPiA+ID4gT24gVHVlLCAwMyBNYXkgMjAy
MiAwMDozODo0NCArMDEwMCwKPiA+ID4gUmFnaGF2ZW5kcmEgUmFvIEFuYW50YSA8cmFuYW50YUBn
b29nbGUuY29tPiB3cm90ZToKPiA+ID4gPgo+ID4gPiA+IEhlbGxvLAo+ID4gPiA+Cj4gPiA+ID4g
Q29udGludWluZyB0aGUgZGlzY3Vzc2lvbiBmcm9tIFsxXSwgdGhlIHNlcmllcyB0cmllcyB0byBh
ZGQgc3VwcG9ydAo+ID4gPiA+IGZvciB0aGUgdXNlcnNwYWNlIHRvIGVsZWN0IHRoZSBoeXBlcmNh
bGwgc2VydmljZXMgdGhhdCBpdCB3aXNoZXMKPiA+ID4gPiB0byBleHBvc2UgdG8gdGhlIGd1ZXN0
LCByYXRoZXIgdGhhbiB0aGUgZ3Vlc3QgZGlzY292ZXJpbmcgdGhlbQo+ID4gPiA+IHVuY29uZGl0
aW9uYWxseS4gVGhlIGlkZWEgZW1wbG95ZWQgYnkgdGhlIHNlcmllcyB3YXMgdGFrZW4gZnJvbQo+
ID4gPiA+IFsxXSBhcyBzdWdnZXN0ZWQgYnkgTWFyYyBaLgo+ID4gPgo+ID4gPiBBcyBpdCB0b29r
IHNvbWUgdGltZSB0byBnZXQgdGhlcmUsIGFuZCB0aGF0IHRoZXJlIHdhcyBzdGlsbCBhIGJ1bmNo
IG9mCj4gPiA+IHRoaW5ncyB0byBhZGRyZXNzLCBJJ3ZlIHRha2VuIHRoZSBsaWJlcnR5IHRvIGFw
cGx5IG15IG93biBmaXhlcyB0byB0aGUKPiA+ID4gc2VyaWVzLgo+ID4gPgo+ID4gPiBQbGVhc2Ug
aGF2ZSBhIGxvb2sgYXQgWzFdLCBhbmQgbGV0IG1lIGtub3cgaWYgeW91J3JlIE9LIHdpdGggdGhl
Cj4gPiA+IHJlc3VsdC4gSWYgeW91IGFyZSwgSSdsbCBtZXJnZSB0aGUgc2VyaWVzIGZvciA1LjE5
Lgo+ID4gPgo+ID4gPiBUaGFua3MsCj4gPiA+Cj4gPiA+ICAgICAgICAgTS4KPiA+ID4KPiA+IFRo
YW5rIHlvdSBmb3Igc3BlZWRpbmcgdXAgdGhlIHByb2Nlc3M7IGFwcHJlY2lhdGUgaXQuIEhvd2V2
ZXIsIHRoZQo+ID4gc2VyaWVzJ3Mgc2VsZnRlc3QgcGF0Y2hlcyBoYXZlIGEgZGVwZW5kZW5jeSBv
biBPbGl2ZXIncwo+ID4gUFNDSV9TWVNURU1fU1VTUEVORCdzIHNlbGZ0ZXN0IHBhdGNoZXMgWzFd
WzJdLiBDYW4gd2UgcHVsbCB0aGVtIGluCj4gPiB0b28/Cj4KPiBVcmdoLi4uIEkgZ3Vlc3MgdGhp
cyBpcyB0aGUgdGltZSB0byBzZXQgc29tZSBncm91bmQgcnVsZXM6Cj4KPiAtIFBsZWFzZSBkb24n
dCBpbnRyb2R1Y2UgZGVwZW5kZW5jaWVzIGJldHdlZW4gc2VyaWVzLCB0aGF0J3MKPiAgIHVubWFu
YWdlYWJsZS4gSSByZWFsbHkgbmVlZCB0byBzZWUgZWFjaCBzZXJpZXMgaW5kZXBlbmRlbnRseSwg
YW5kIGlmCj4gICB0aGVyZSBpcyBhIG1lcmdlIGNvbmZsaWN0LCB0aGF0J3MgbXkgam9iIHRvIGZp
eCAoYW5kIEkgZG9uJ3QgcmVhbGx5Cj4gICBtaW5kKS4KPgo+IC0gSWYgdGhlcmUgaXMgYSBkZXBl
bmRlbmN5IGJldHdlZW4gc2VyaWVzLCBwbGVhc2UgcG9zdCBhIHZlcnNpb24gb2YKPiAgIHRoZSBy
ZXF1aXJlZCBwYXRjaGVzIGFzIGEgcHJlZml4IHRvIHlvdXIgc2VyaWVzLCBhc3N1bWluZyB0aGlz
Cj4gICBwcmVmaXggaXMgaXRzZWxmIHN0YW5kYWxvbmUuIElmIGl0IGlzbid0LCB0aGVuIHNvbWV0
aGluZyByZWFsbHkgaXMKPiAgIHdyb25nLCBhbmQgdGhlIHNlcmllcyBzaG91bGQgYmUgcmVzcGxp
dC4KPgo+IC0gWW91IGFsc28gc2hvdWxkIGJlIGJhc2luZyB5b3VyIHNlcmllcyBvbiBhbiAqb2Zm
aWNpYWwqIHRhZyBmcm9tCj4gICBMaW51cycgdHJlZSAocHJlZmVyYWJseSAtcmMxLCAtcmMyIG9y
IC1yYzMpLCBhbmQgbm90IHNvbWV0aGluZwo+ICAgcmFuZG9tIGxpa2UgYW55IG9kZCBjb21taXQg
ZnJvbSB0aGUgS1ZNIHRyZWUgKEkgaGFkIGNvbmZsaWN0cyB3aGlsZQo+ICAgYXBwbHlpbmcgdGhp
cyBvbiAtcmMzLCBwcm9iYWJseSBkdWUgdG8gdGhlIG5vbi1hZHZlcnRpc2VkIGRlcGVuZGVuY3kK
PiAgIG9uIE9saXZlcidzIHNlcmllcykuCj4KVGhhbmtzIGZvciBwaWNraW5nIHRoZSBkZXBlbmRl
bmN5IHBhdGNoZXMuIEknbGwga2VlcCB0aGVzZSBtaW5kIHRoZQpuZXh0IHRpbWUgSSBwdXNoIGNo
YW5nZXMuCgo+ID4KPiA+IGFhcmNoNjQvaHlwZXJjYWxscy5jOiBJbiBmdW5jdGlvbiDigJhndWVz
dF90ZXN0X2h2Y+KAmToKPiA+IGFhcmNoNjQvaHlwZXJjYWxscy5jOjk1OjMwOiBlcnJvcjogc3Rv
cmFnZSBzaXplIG9mIOKAmHJlc+KAmSBpc27igJl0IGtub3duCj4gPiAgICA5NSB8ICAgICAgICAg
c3RydWN0IGFybV9zbWNjY19yZXMgcmVzOwo+ID4gICAgICAgfCAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF5+fgo+ID4gYWFyY2g2NC9oeXBlcmNhbGxzLmM6MTAzOjE3OiB3YXJuaW5nOiBp
bXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbgo+ID4g4oCYc21jY2NfaHZj4oCZIFstV2lt
cGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQo+ID4gICAxMDMgfCAgICAgICAgICAgICAgICAg
c21jY2NfaHZjKGhjX2luZm8tPmZ1bmNfaWQsIGhjX2luZm8tPmFyZzEsIDAsCj4gPiAwLCAwLCAw
LCAwLCAwLCAmcmVzKTsKPiA+ICAgICAgIHwgICAgICAgICAgICAgICAgIF5+fn5+fn5+fgo+ID4K
Pgo+IEkndmUgcGlja2VkIHRoZSB0d28gcGF0Y2hlcywgd2hpY2ggbWVhbnMgdGhleSB3aWxsIG1v
c3QgbGlrZWx5IGFwcGVhcgo+IHR3aWNlIGluIHRoZSBoaXN0b3J5LiBJbiB0aGUgZnV0dXJlLCBw
bGVhc2UgcmVhY2ggb3V0IHNvIHRoYXQgd2UgY2FuCj4gb3JnYW5pc2UgdGhpcyBiZXR0ZXIuCj4K
PiA+IEFsc28sIGp1c3QgYSBjb3VwbGUgb2YgcmVhZGFiaWxpdHkgbml0cyBpbiB0aGUgZml4ZWQg
dmVyc2lvbjoKPiA+Cj4gPiAxLiBQYXRjaC0yLzksIGh5cGVyY2FsbC5jOmt2bV9odmNfY2FsbF9k
ZWZhdWx0X2FsbG93ZWQoKSwgaW4gdGhlCj4gPiAnZGVmYXVsdCcgY2FzZSwgZG8geW91IHRoaW5r
IHdlIHNob3VsZCBwcm9iYWJseSBhZGQgYSBzbWFsbCBjb21tZW50Cj4gPiB0aGF0IG1lbnRpb25z
IHdlIGFyZSBjaGVja2luZyBmb3IgZnVuY19pZCBpbiB0aGUgUFNDSSByYW5nZT8KPgo+IER1bXBl
ZCBhIG9uZS1saW5lciB0aGVyZS4KPgo+ID4gMi4gUGF0Y2gtMi85LCBhcm1faHlwZXJjYWxsLmgs
IGNsZWFyIGFsbCB0aGUgbWFjcm9zIGluIHRoaXMgcGF0Y2gKPiA+IGl0c2VsZiBpbnN0ZWFkIG9m
IGRvaW5nIGl0IGluIGluY3JlbWVudHMgKHVubGVzcyB0aGVyZSdzIHNvbWUgcmVhc29uCj4gPiB0
aGF0IEknbSBtaXNzaW5nKT8KPgo+IEFoLCByZWJhc2luZyBsZWZ0b3ZlcnMsIG5vdyBnb25lLgo+
Cj4gSSd2ZSBwdXNoZWQgYW4gdXBkYXRlZCBicmFuY2ggYWdhaW4sIHBsZWFzZSBoYXZlIGEgbG9v
ay4KPgpUaGFua3MgZm9yIGFkZHJlc3NpbmcgdGhlc2UuIFRoZSBzZXJpZXMgbG9va3MgZ29vZCBu
b3cuCgpSZWdhcmRzLApSYWdoYXZlbmRyYQo+ICAgICAgICAgTS4KPgo+IC0tCj4gV2l0aG91dCBk
ZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jlc3MgaXMgbm90IHBvc3NpYmxlLgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

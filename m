Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69F2C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  4 Mar 2022 19:01:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53EE649B0C;
	Fri,  4 Mar 2022 14:01:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LgCipz2i4J6S; Fri,  4 Mar 2022 14:01:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DFD549DF6;
	Fri,  4 Mar 2022 14:01:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D469E4291D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 14:01:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OkZ99RjSYomT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Mar 2022 14:01:45 -0500 (EST)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6D4740D26
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 14:01:45 -0500 (EST)
Received: by mail-pj1-f41.google.com with SMTP id
 z12-20020a17090ad78c00b001bf022b69d6so7640502pju.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Mar 2022 11:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=aWtPp9gHavbCe/72TWGgyPSN8olgIQaG6jqiqoJFlvo=;
 b=T6cZTeQpCWywuAIUeZSbXRXspUMqzhtz/6tGTT/oMw4QxfOPTtToFpWO+keRiJvHqF
 8JSl2KEqr7eM0ff447jt4in3NZLFaKYH+way7DVAbtyykbxIOezHLNgL/07Lq4W38S8x
 7QJOvo7D+dtfY62vdxaeSa5832NDBy1wcRtoSpTKpMpnrvIGDHb4yEZa485WSraY1Mis
 K9sDj747pso9N9WHul3YQ6TO3HWakI6UTzZIX/3EStFZOurxJzKWzOy9Mogkf/7RTzKA
 CLgt0ljFTI8ZuzSSnwmhygmATrSeHYYPBA+6opn5ARig/FsZtyz9oAR2SZmJcDYjHsW8
 1qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=aWtPp9gHavbCe/72TWGgyPSN8olgIQaG6jqiqoJFlvo=;
 b=BBEcBNcJCy9UsI/ewIfCA/LTosoqDEOW98av42Dq24mN6y0KdUVWDeLWTnzT0r0aL1
 j7hiTdGJQbOkU/qwmtRwwdvs+pkFi+tLj3NjmhUgfQnrZvb/j2O3qKIA+K5a5T1k61QK
 4/MbLQ2YkNgT+AHdOQYYVRUPpBqc8oUdQDC6GN4p+o4OSaISh2FafnJIuKfVqLuuF39x
 GGCC4944hwdE8lVagfO1RiJut5qCs4vMAKklbBPGhRPq/YJvNzce/EocQ5u2x6ljFRol
 CWINpQHCS1PVPzu3urvUxLOoU+ZEf1Wfv6ZpyVjhv8hbo+KwDFdAhUFIHMtenKtjmQmi
 6SvQ==
X-Gm-Message-State: AOAM530b/N073wNLaoRyvKLnGBlINOrFRZXj14QkjcJnmjxEcNtwp8ao
 2fLnyYPuGdVtQlhJhbKFEWnArMNuf9DHvw==
X-Google-Smtp-Source: ABdhPJwIYIZYgdYmZztlZdIGYIS82jCeVXSf1N3R2HJLRYsb6Fdyu/sqywudX8SMQNietyqX8pg5fQ==
X-Received: by 2002:a17:90b:350c:b0:1bf:1dc5:1c3d with SMTP id
 ls12-20020a17090b350c00b001bf1dc51c3dmr7361081pjb.53.1646420504531; 
 Fri, 04 Mar 2022 11:01:44 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 z2-20020a17090a170200b001bf2d530d64sm2136862pjd.2.2022.03.04.11.01.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Mar 2022 11:01:43 -0800 (PST)
Date: Fri, 4 Mar 2022 11:01:40 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
Message-ID: <YiJiFD2ROBHnVSyU@google.com>
References: <20220302172144.2734258-1-ricarkol@google.com>
 <20220302172144.2734258-3-ricarkol@google.com>
 <Yh/XgYAbqCYguegJ@google.com> <Yh/gyN7Xu54SpWBx@google.com>
 <87h78etasf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87h78etasf.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

T24gRnJpLCBNYXIgMDQsIDIwMjIgYXQgMDc6NTI6MDBBTSArMDAwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IE9uIFdlZCwgMDIgTWFyIDIwMjIgMjE6MjU6MjggKzAwMDAsCj4gUmljYXJkbyBLb2xs
ZXIgPHJpY2Fya29sQGdvb2dsZS5jb20+IHdyb3RlOgo+ID4gCj4gPiBIaSBPbGl2ZXIsCj4gPiAK
PiA+IE9uIFdlZCwgTWFyIDAyLCAyMDIyIGF0IDA4OjQ1OjUzUE0gKzAwMDAsIE9saXZlciBVcHRv
biB3cm90ZToKPiA+ID4gSGkgUmljYXJkbywKPiA+ID4gCj4gPiA+IE9uIFdlZCwgTWFyIDAyLCAy
MDIyIGF0IDA5OjIxOjQzQU0gLTA4MDAsIFJpY2FyZG8gS29sbGVyIHdyb3RlOgo+ID4gPiA+IEFk
ZCBhbiBhcmNoX3RpbWVyIGVkZ2UtY2FzZXMgc2VsZnRlc3QuIEZvciBub3csIGp1c3QgYWRkIHNv
bWUgYmFzaWMKPiA+ID4gPiBzYW5pdHkgY2hlY2tzLCBhbmQgc29tZSBzdHJlc3MgY29uZGl0aW9u
cyAobGlrZSB3YWl0aW5nIGZvciB0aGUgdGltZXJzCj4gPiA+ID4gd2hpbGUgcmUtc2NoZWR1bGlu
ZyB0aGUgdmNwdSkuIFRoZSBuZXh0IGNvbW1pdCB3aWxsIGFkZCB0aGUgYWN0dWFsIGVkZ2UKPiA+
ID4gPiBjYXNlIHRlc3RzLgo+ID4gPiA+IAo+ID4gPiA+IFRoaXMgdGVzdCBmYWlscyB3aXRob3V0
IGE4NjdlOWQwY2MxICJLVk06IGFybTY0OiBEb24ndCBtaXNzIHBlbmRpbmcKPiA+ID4gPiBpbnRl
cnJ1cHRzIGZvciBzdXNwZW5kZWQgdkNQVSIuCj4gPiA+ID4gCj4gPiA+IAo+ID4gPiBUZXN0aW5n
IHRpbWVyIGNvcnJlY3RuZXNzIGlzIGV4dHJlbWVseSBjaGFsbGVuZ2luZyB0byBkbyB3aXRob3V0
Cj4gPiA+IGluaGVyZW50IGZsYWtpbmVzcy4gSSBoYXZlIHNvbWUgY29uY2VybnMgYWJvdXQgdGhl
IGV4cGVjdGF0aW9ucyB0aGF0IGEKPiA+ID4gdGltZXIgSVJRIHNob3VsZCBmaXJlIGluIGEgZ2l2
ZW4gYW1vdW50IG9mIHRpbWUsIGFzIGl0IGlzIHBvc3NpYmxlIHRvCj4gPiA+IGZsYWtlIGZvciBh
bnkgbnVtYmVyIG9mIGJlbmlnbiByZWFzb25zIChzdWNoIGFzIGhpZ2ggQ1BVIGxvYWQgaW4gdGhl
Cj4gPiA+IGhvc3QpLgo+ID4gPiAKPiA+ID4gV2hpbGUgdGhlIGFyY2hpdGVjdHVyZSBtYXkgc3Vn
Z2VzdCB0aGF0IHRoZSB0aW1lciBzaG91bGQgZmlyZSBhcyBzb29uIGFzCj4gPiA+IENWQUwgaXMg
bWV0Ogo+ID4gPiAKPiA+ID4gICBUaW1lckNvbmRpdGlvbk1ldCA9ICgoKENvdW50ZXJbNjM6MF0g
4oCTIE9mZnNldFs2MzowXSlbNjM6MF0gLSBDb21wYXJlVmFsdWVbNjM6MF0pID49IDApCj4gPiA+
IAo+ID4gPiBIb3dldmVyLCB0aGUgYXJjaGl0ZWN0dXJlIGlzIGV4dHJlbWVseSBpbXByZWNpc2Ug
YXMgdG8gd2hlbiBhbiBpbnRlcnJ1cHQKPiA+ID4gc2hvdWxkIGJlIHRha2VuOgo+ID4gPiAKPiA+
ID4gICBJbiB0aGUgYWJzZW5jZSBvZiBhIHNwZWNpZmljIHJlcXVpcmVtZW50IHRvIHRha2UgYW4g
aW50ZXJydXB0LCB0aGUKPiA+ID4gICBhcmNoaXRlY3R1cmUgb25seSByZXF1aXJlcyB0aGF0IHVu
bWFza2VkIHBlbmRpbmcgaW50ZXJydXB0cyBhcmUgdGFrZW4KPiA+ID4gICBpbiBmaW5pdGUgdGlt
ZS4gW0RESTA0ODdHLmIgRDEuMTMuNCAiUHJpb3JpdGl6YXRpb24gYW5kIHJlY29nbml0aW9uIG9m
Cj4gPiA+ICAgaW50ZXJydXB0cyJdCj4gPiA+IAo+ID4gPiBJdCBzZWVtcyB0byBtZSB0aGF0IHRo
ZSBvbmx5IHRoaW5nIHdlIGNhbiBwb3NpdGl2ZWx5IGFzc2VydCBpcyB0aGF0IGEKPiA+ID4gdGlt
ZXIgaW50ZXJydXB0IHNob3VsZCBuZXZlciBiZSB0YWtlbiBlYXJseS4gTm93IC0tIEkgYWdyZWUg
dGhhdCB0aGVyZQo+ID4gPiBpcyB2YWx1ZSBpbiB0ZXN0aW5nIHRoYXQgdGhlIGludGVycnVwdCBi
ZSB0YWtlbiBpbiBib3VuZGVkIHRpbWUsIGJ1dCBpdHMKPiA+ID4gaGFyZCB0byBwaWNrIGEgZ29v
ZCB2YWx1ZSBmb3IgaXQuCj4gPiAKPiA+IFllcywgYSB0aW1lciB0aGF0IG5ldmVyIGZpcmVzIHBh
c3NlcyB0aGUgdGVzdCwgYnV0IGl0J3Mgbm90IHZlcnkgdXNlZnVsLgo+ID4gCj4gPiBJIHNhdyBk
ZWxheSBpc3N1ZXMgaW1tZWRpYXRlbHkgYWZ0ZXIgdGVzdGluZyB3aXRoIFFFTVUuIEkndmUgYmVl
biBwbGF5ZWQKPiA+IHdpdGggdmFsdWVzIGFuZCBmb3VuZCB0aGF0IDFtcyBpcyBlbm91Z2ggZm9y
IGFsbCBvZiBteSBydW5zIChRRU1VCj4gPiBpbmNsdWRlZCkgdG8gcGFzcyAoMTAwMDAgaXRlcmF0
aW9ucyBjb25jdXJyZW50bHkgb24gYWxsIG15IDY0IGNwdXMpLiBJCj4gPiBqdXN0IGNoZWNrZWQg
aW4gdGhlIGZhc3QgbW9kZWwgYW5kIDFtcyBzZWVtcyB0byBiZSBlbm91Z2ggYXMgd2VsbAo+ID4g
KGFsdGhvdWdoIEkgZGlkbid0IGNoZWNrIGZvciBzbyBsb25nKS4KPiA+IAo+ID4gCS8qIDFtcyBz
b3VuZHMgYSBiaXQgZXhjZXNzaXZlLCBidXQgUUVNVS1UQ0cgaXMgc2xvdy4gKi8KPiA+IAkjZGVm
aW5lIFRFU1RfTUFSR0lOX1VTCQkJMTAwMFVMTAo+IAo+IEknbSBub3Qgc3VyZSB0aGF0J3MgZXZl
biByZWFsaXN0aWMuIEkgY2FuIGFyYml0cmFyeSBkZWxheSB0aG9zZSBieQo+IG92ZXJzdWJzY3Jp
YmluZyB0aGUgc3lzdGVtLgo+IAo+ID4gCj4gPiA+IAo+ID4gPiBQZXJoYXBzIGRvY3VtZW50aW5n
IHRoZSBwb3NzaWJpbGl0eSBvZiBmbGFrZXMgaW4gdGhlIHRlc3QgaXMgd2FycmFudGVkLAo+ID4g
PiBhbG9uZyB3aXRoIHNvbWUga25vYnMgdG8gYWRqdXN0IHRoZXNlIHZhbHVlcyBmb3IgYW55IHBh
cnRpY3VsYXJseSBiYWQKPiA+ID4gaW1wbGVtZW50YXRpb24uCj4gPiAKPiA+IFdoYXQgYWJvdXQg
aGF2aW5nIGEgY21kbGluZSBhcmcgdG8gZW5hYmxlIHRob3NlIHRlc3RzPwo+IAo+IEhvdyBpcyB0
aGF0IGhhbmRsZWQgaW4ga3ZtLXVuaXQtdGVzdHM/IEknZCByYXRoZXIgYXZvaWQgc3BlY2lhbAo+
IGFyZ3VtZW50cywgYXMgdGhleSB3aWxsIG5ldmVyIGJlIHNldC4gQWxsIHRlc3RzIHNob3VsZCBy
dW4gYnkgZGVmYXVsdC4KClRoZXJlJ3MgdGhpcyBsYXRlbmN5IHRlc3QgdGhhdCBjaGVja3MgdGhh
dCB0aGUgbGF0ZW5jeSBmb3IgYSAxMG1zIHRpbWVyCmlzIG5vdCBkZWxheWVkIGJ5IG1vcmUgdGhh
biAxMG1zIChhZnRlciB0aGUgZmlyc3QgMTBtcyk6CgoJcmVwb3J0KHRlc3RfY3ZhbF8xMG1zZWMo
aW5mbyksICJsYXRlbmN5IHdpdGhpbiAxMCBtcyIpOwoKSnVzdCB0byBiZSBzYWZlIEkgd2lsbCBq
dXN0IHJlbW92ZSB0aGUgY2hlY2tzIGZvciB0aW1lcnMgZmlyaW5nIGJlZm9yZQpzb21lIG1hcmdp
biAobm90IGV2ZW4gd2l0aCBhIHNwZWNpYWwgYXJndW1lbnQpLgoKVGhhbmtzLApSaWNhcmRvCgo+
IAo+IAlNLgo+IAo+IC0tIAo+IFdpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dy
ZXNzIGlzIG5vdCBwb3NzaWJsZS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==

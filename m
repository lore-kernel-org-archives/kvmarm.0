From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug,
 add SW break point support
Date: Wed, 22 Apr 2015 10:46:47 +0100
Message-ID: <87383s7awo.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-7-git-send-email-alex.bennee@linaro.org>
 <CADt_bzh=zhSmoQnKxp5cUski3S=riYG5AnmCsm=qeTSjm=cprA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61FF04E2D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2015 05:38:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xUVjwXkbMjCh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2015 05:38:27 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 342854E2CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2015 05:38:26 -0400 (EDT)
In-reply-to: <CADt_bzh=zhSmoQnKxp5cUski3S=riYG5AnmCsm=qeTSjm=cprA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, dahi@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ClpoaWNoYW8gSHVhbmcgPHpoaWNoYW8uaHVhbmdAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBPbiBU
dWUsIE1hciAzMSwgMjAxNSBhdCAwNDowODowNFBNICswMTAwLCBBbGV4IEJlbm7DqWUgd3JvdGU6
Cj4+IFRoaXMgYWRkcyBzdXBwb3J0IGZvciBTVyBicmVha3BvaW50cyBpbnNlcnRlZCBieSB1c2Vy
c3BhY2UuCj4+Cj4+IFdlIGRvIHRoaXMgYnkgdHJhcHBpbmcgYWxsIEJLUFQgZXhjZXB0aW9ucyBp
biB0aGUKPj4gaHlwZXJ2aXNvciAoTURDUl9FTDJfVERFKS4KPgo+IHdoeSBzaG91bGQgd2UgdHJh
cCBhbGwgZGVidWcgZXhjZXB0aW9ucz8KPgo+IFRoZSB0cmFwIGZvciBjcDE0IHJlZ2lzdGVyIHIv
dyBzZWVtcyBlbm91Z2ggdG8gcmVjb3JkIHJlbGV2YW50Cj4gaW5mb3JtYXRpb25zIHRvIGNvbnRl
eHQgc3dpdGNoIHRoZSBkYmcgcmVnaXN0ZXIgd2hpbGUgbmVjY2Vzc2FyeS4KCkxldHMgdGhpbmsg
YWJvdXQgdGhpcyBjYXNlIHdoZW4gdGhlIFNXIGJyZWFrcG9pbnQgZXhjZXB0aW9uIG9jY3VyczoK
CklmIEtWTSBkb2Vzbid0IHRyYXAgaXQgYW5kIHBhc3MgaXQgYmFjayB0byB1c2Vyc3BhY2UgdG8g
aGFuZGxlIGl0IHdvdWxkCmhhdmUgdG8gZGVsaXZlciBpdCB0byB0aGUgZ3Vlc3QuIFRoZSBndWVz
dCBub3QgaGF2aW5nIGluc2VydGVkIHRoZQpicmVha3BvaW50IGluIHRoZSBmaXJzdCBwbGFjZSB3
b3VsZCBnZXQgdmVyeSBjb25mdXNlZC4KClNvIHdoYXQgd2UgYWN0dWFsbHkgZG8gaXMgcmUtcm91
dGUgdGhlIGV4Y2VwdGlvbiB0byB0aGUgaHlwZXJ2aXNvciBhbmQKc3RvcCB0aGUgVk0gYW5kIHJl
dHVybiB0byB1c2Vyc3BhY2Ugd2l0aCB0aGUgZGVidWcgaW5mb3JtYXRpb24uIE9uY2UgaW4KUUVN
VSB3ZSBjaGVjayB0byBzZWUgaWYgdGhlIFNXIGJyZWFrcG9pbnQgd2FzIG9uZSBvZiB0aGUgb25l
cyB3ZQppbnNlcnRlZCBhdCB3aGljaCBwb2ludCBjb250cm9sIGlzIHBhc3NlZCBiYWNrIHRvIHRo
ZSBob3N0IEdEQiAoYXR0YWNoZWQKdmlhIHRoZSBHREIgc3R1YiBpbiBRRU1VKS4gSWYgaXQgaXMg
bm90IGEgYnJlYWtwb2ludCB3aGljaCB3YXMgc2V0LXVwIGJ5CnRoZSBob3N0IHRoZW4gaXQgbXVz
dCBiZSBvbmUgZm9yIHRoZSBndWVzdCBhdCB3aGljaCBwb2ludCB3ZSBuZWVkIHRvCmVuc3VyZSB0
aGUgZXhjZXB0aW9uIGlzIGRlbGl2ZXJlZCB0byB0aGUgZ3Vlc3QgZm9yIGl0IHRvIHByb2Nlc3Mu
CgotLSAKQWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

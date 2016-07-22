From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v9 0/6] KVM: arm/arm64: gsi routing support
Date: Fri, 22 Jul 2016 18:33:52 +0100
Message-ID: <57925900.8020104@arm.com>
References: <1469204442-3220-1-git-send-email-eric.auger@redhat.com>
 <20160722171354.GC11512@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D64BE49B7B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:27:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DPPvTHYtl3xT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:27:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D4AD49B79
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:27:38 -0400 (EDT)
In-Reply-To: <20160722171354.GC11512@potion>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

T24gMjIvMDcvMTYgMTg6MTMsIFJhZGltIEtyxI1tw6HFmSB3cm90ZToKPiAyMDE2LTA3LTIyIDE2
OjIwKzAwMDAsIEVyaWMgQXVnZXI6Cj4+IFdpdGggdGhlIGFkdmVudCBvZiBHSUN2MyBJVFMgaW4t
a2VybmVsIGVtdWxhdGlvbiwgS1ZNIE1TSSByb3V0aW5nCj4+IGJlY29tZXMgbWFuZGF0ZWQgZm9y
IHByb3BlciBWSVJUSU8tUENJIHZob3N0IGludGVncmF0aW9uLgo+IAo+IENoYW5nZXMgdG8gaW50
ZXJmYWNlcyBhbmQgY29tbW9uIGNvZGUgbG9vayBvaywKPiAKPiBBY2tlZC1ieTogUmFkaW0gS3LE
jW3DocWZIDxya3JjbWFyQHJlZGhhdC5jb20+CgpJJ2xsIGxldCBpdCBzaW5rIGludG8gLW5leHQg
Zm9yIGEgZmV3IGRheXMsIHNvIHRoYXQgSSBjYW4gcmVydW4gbXkKbm9uLXJlZyBzdHVmZiwgYW5k
IHdpbGwgc2VuZCBhbm90aGVyIFBSIGlmIGV2ZXJ5dGhpbmcgdHVybnMgZ3JlZW4uCgpUaGFua3Mg
eW91IGJvdGggZm9yIHRoZSBxdWljayB0dXJuYXJvdW5kIQoKCU0uCi0tIApKYXp6IGlzIG5vdCBk
ZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K

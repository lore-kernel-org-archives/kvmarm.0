From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 1/2] KVM: Enforce error in ioctl for compat tasks when
 !KVM_COMPAT
Date: Thu, 21 Jun 2018 17:03:55 +0200
Message-ID: <20180621150355.GA21546@flask>
References: <20180619094251.8586-1-marc.zyngier@arm.com>
 <20180619094251.8586-2-marc.zyngier@arm.com>
 <20180619100134.4loab4jtnfdzrpxu@lakrids.cambridge.arm.com>
 <8e4d21bf-d30f-ac66-3017-2badf6a29ec5@arm.com>
 <22acc63b-8737-39b4-d4d4-87927a49fa8c@de.ibm.com>
 <f4f2dcd6-9ef7-f7fa-8ec4-f320d4a649ac@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3634A0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:54:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tGy2L4emtCG7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:54:20 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E1014A0E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:52:04 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <f4f2dcd6-9ef7-f7fa-8ec4-f320d4a649ac@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

MjAxOC0wNi0yMSAxMjo0MCswMTAwLCBNYXJjIFp5bmdpZXI6Cj4gUmFkaW0sIFBhb2xvOiBhcmUg
eW91IGhhcHB5IHdpdGggbWUgdGFraW5nIHRoaXMgdGhyb3VnaCB0aGUga3ZtYXJtIHRyZWU/CgpZ
ZXMsIHBsZWFzZSBkby4KCkFja2VkLWJ5OiBSYWRpbSBLcsSNbcOhxZkgPHJrcmNtYXJAcmVkaGF0
LmNvbT4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==

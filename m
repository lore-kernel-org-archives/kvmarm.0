From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 02/12] KVM: define common KVM_GUESTDBG_USE_SW/HW_BP bits
Date: Fri, 15 May 2015 17:58:38 +0200
Message-ID: <555617AE.9030508@de.ibm.com>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF2D65177B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 11:49:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zGUMIzcHhxHr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 11:49:37 -0400 (EDT)
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B7A6516FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 11:49:36 -0400 (EDT)
Received: from /spool/local
 by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <borntraeger@de.ibm.com>;
 Fri, 15 May 2015 16:58:47 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com
 (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
 by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 18AA817D8056
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 16:59:35 +0100 (BST)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com
 [9.149.37.216])
 by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 t4FFwjeM9306498
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 15:58:45 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
 by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 t4FFweC1021317
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 09:58:45 -0600
In-Reply-To: <1431700035-23479-3-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: Tony Krowiak <akrowiak@linux.vnet.ibm.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-s390@vger.kernel.org, Michael Mueller <mimu@linux.vnet.ibm.com>, Nadav Amit <namit@cs.technion.ac.il>, Michael Ellerman <mpe@ellerman.id.au>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, jan.kiszka@siemens.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, r65777@freescale.com, Cornelia Huck <cornelia.huck@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Farman <farman@linux.vnet.ibm.com>, linux-api@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Dominik Dingel <dingel@linux.vnet.ibm.com>, dahi@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: kvmarm@lists.cs.columbia.edu

QW0gMTUuMDUuMjAxNSB1bSAxNjoyNyBzY2hyaWViIEFsZXggQmVubsOpZToKPiBpbmRleCBlZjFh
NWZjLi5hY2E0Zjg2IDEwMDY0NAo+IC0tLSBhL2FyY2gvczM5MC9pbmNsdWRlL3VhcGkvYXNtL2t2
bS5oCj4gKysrIGIvYXJjaC9zMzkwL2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPiBAQCAtMTE0LDgg
KzExNCw2IEBAIHN0cnVjdCBrdm1fZnB1IHsKPiAgCV9fdTY0IGZwcnNbMTZdOwo+ICB9Owo+IAo+
IC0jZGVmaW5lIEtWTV9HVUVTVERCR19VU0VfSFdfQlAJCTB4MDAwMTAwMDAKPiAtCgoKPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2t2
bS5oCj4gaW5kZXggNzBhYzY0MS4uN2M1ZGQxMSAxMDA2NDQKPiAtLS0gYS9pbmNsdWRlL3VhcGkv
bGludXgva3ZtLmgKPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKWy4uLl0KPiArI2Rl
ZmluZSBLVk1fR1VFU1REQkdfVVNFX1NXX0JQCQkoMSA8PCAxNikKPiArI2RlZmluZSBLVk1fR1VF
U1REQkdfVVNFX0hXX0JQCQkoMSA8PCAxNykKClRoaXMgaXMgYSBhYmkgYnJlYWsgZm9yIHMzOTAs
IG5vPwoKRGF2aWQgZG8geW91IHJlbWVtYmVyIHdoeSB3ZSBkaWQgbm90IHVzZSBTV19CUD8KCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWls
aW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNv
bHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

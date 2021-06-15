Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C4EC48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA03C6142E
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 09:45:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA03C6142E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=metux.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4514B0EA;
	Tue, 15 Jun 2021 05:45:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6o+JujOnbMsl; Tue, 15 Jun 2021 05:45:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9C74B0F9;
	Tue, 15 Jun 2021 05:45:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682874B0D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 04:37:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LqzQB1gVxiw4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 04:37:55 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0238C4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 04:37:54 -0400 (EDT)
Received: from [192.168.1.155] ([95.115.9.120]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MYcy3-1lpPX61RGl-00VeCh; Tue, 15 Jun 2021 10:37:39 +0200
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>, Fuad Tabba <tabba@google.com>
References: <20210614212155.1670777-1-jingzhangos@google.com>
From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <b86aa6df-5fd7-d705-1688-4d325df6f7d9@metux.net>
Date: Tue, 15 Jun 2021 10:37:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210614212155.1670777-1-jingzhangos@google.com>
Content-Language: tl
X-Provags-ID: V03:K1:Vod45xLxHxZ5p8qYKvuWym3LEAiarmlv0Xbt34OpNBV9uy1sBdE
 IRftON+oudc8QVSK3OpycOl49aHJfySAgkANRqrTI39LcdQIXpjA7mxltjpeNzUcQSldpbN
 9MatQnRvvRMJJ8elPHcd2BkxKXtnpLxALuiGllUwQeIJ/pSfjl/1Ju+2MmxGm86GlBu1W06
 ZMtU7WHK45h2IdXcp/e8g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+53FXRRHLqc=:mz+uz7bhnpeydAZf0N2025
 PzwGuvUWyPVQfHIrPDNsiRUyENR8k8pU+IrQTGZS1wnh9dAW8iuHrnc1m2pJ3oMjaQSkDQfYE
 CitMcMEor434oAPJQjN+scqfRgySjAt2AMJpYyCkXEnjuNLL435UQVMezynLHSeRwuZ3mbYhv
 wwNIBxhtwjP7SVCR9sHWQMJzG+1zH/4+qxGxAb9sDf80fkBI07uRQz5xuvmLVq7WGoWF74/Us
 BQiBgnydw4wY4V1J5Y5yEAwuoKhnbDEyPZHgJvQT1w1FMWuELbaEz6VH6F+SXOPaAlywjQe7q
 WGTk8EjDeLtaCIS9fu2JoA0zWjjS4a4EEo684bMWJScBce+ezZ/9MV7YfgKmdb16Tr0FIJWya
 +bz0ZJ5j2y6JQlx5SiGGMEUCnQUBNS7Fm5VA0Sa3ZK1jXEY5/DPcdideck40Dn+2OPAZuXtU9
 ESR5huX3pYZYRU/wFSEiLE4jZIbf867UrKIgkQCDL+90WY3iyjt/tICjAmssa+jDfqp5+UZuZ
 2L9tw9OzjAAntKVmcEinnI=
X-Mailman-Approved-At: Tue, 15 Jun 2021 05:45:20 -0400
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

T24gMTQuMDYuMjEgMjM6MjEsIEppbmcgWmhhbmcgd3JvdGU6CgpIaSwKCj4gVGhpcyBwYXRjaHNl
dCBwcm92aWRlcyBhIGZpbGUgZGVzY3JpcHRvciBmb3IgZXZlcnkgVk0gYW5kIFZDUFUgdG8gcmVh
ZAo+IEtWTSBzdGF0aXN0aWNzIGRhdGEgaW4gYmluYXJ5IGZvcm1hdC4KCkkndmUgbWlzc2VkIHRo
ZSBkaXNjdXNzaW9ucyBvZiBwcmV2aW91cyB2ZXJzaW9ucywgc28gcGxlYXNlIGZvcmdpdmUgbXkK
c3R1cGlkIHF1ZXN0aW9uczoKCiogd2h5IGlzIGl0IGJpbmFyeSBpbnN0ZWFkIG9mIHRleHQgPyBp
cyBpdCBzbyB2ZXJ5IGhpZ2ggdm9sdW1lIHRoYXQKICAgaXQgcmVhbGx5IG1hdHRlcnMgPwoqIGhv
dyB3aWxsIHBvc3NpYmxlIGZ1dHVyZSBleHRlbnNpb25zIG9mIHRoZSB0ZWxlbWV0cnkgcGFja2V0
cyB3b3JrID8KKiBhcmVuJ3QgdGhlcmUgb3RoZXIgbWVhbnMgdG8gZ2V0IHRoaXMgZmQgaW5zdGVh
ZCBvZiBhbiBpb2N0bCgpIG9uIHRoZQogICBWTSBmZCA/IHNvbWV0aGluZyBtb3JlIGZyb20gdGhl
IG91dHNpZGUgKGVnLiBzeXNmcy9wcm9jZnMpCiogaG93IHdpbGwgdGhhdCByZWxhdGUgdG8gb3Ro
ZXIgaHlwZXJ2aXNvcnMgPwoKU29tZSBub3RlcyBmcm9tIHRoZSBvcGVyYXRpbmcgcGVyc3BlY3Rp
dmU6CgpJbiB0eXBpY2FsIGRhdGFjZW50ZXJzIHdlJ3ZlIGdvdCB2YXJpb3VzIG1vbml0b3Jpbmcg
dG9vbHMgdGhhdCBhcmUgYWJsZQp0byBjYXRjaCB1cCBsb3RzIG9mIGRhdGEgZnJvbSBkaWZmZXJl
bnQgc291cmNlcyAoZXNwZWNpYWxseSBmaWxlcykuIElmCmFuIG9wZXJhdG9yIGUuZy4gaXMgaW50
ZXJlc3RlZCBpbiBzb21ldGhpbmcgaW4gaGFwcGVuaW5nIGluIHNvbWUgZmlsZQooZS5nLiBpbiAv
cHJvYyBvZiAvc3lzKSwgaXQncyBxdWl0ZSB0cml2aWFsIC0ganVzdCBjb25maWd1cmUgeWV0IGFu
b3RoZXIKcHJvYmUgKG1heWJlIHNvbWUgcmVnZXggZm9yIHBhcnNpbmcpIGFuZCBkb25lLiBBdXRv
bWF0aWNhbGx5IGZlZCBpbiBoaXMKJG1vbml0b3Jpbmdfc29sdXRpb24gKGUuZy4gbmFnaW9zLCBF
TEssIFNwbHVuaywgd2hhdHNub3QpCgpXaXRoIHlvdXIgYXBwcm9hY2gsIGl0J3Mgbm90IHRoYXQg
c2ltcGxlOiBub3cgdGhlIG9wZXJhdG9yIG5lZWRzIHRvCmNyZWF0ZSAoYW5kIGRlcGxveSBhbmQg
bWFuYWdlKSBhIHNlcGFyYXRlIGFnZW50IHRoYXQgc29tZWhvdyByZWNlaXZlcwp0aGF0IGZkIGZy
b20gdGhlIFZNTSwgcmVhZHMgYW5kIHBhcnNlcyB0aGF0IHNwZWNpZmljIGJpbmFyeSBzdHJlYW0K
YW5kIGZpbmFsbHkgcHVzaGVzIGl0IGludG8gdGhlIG1vbml0b3JpbmcgaW5mcmFzdHJ1Y3R1cmUu
IE9yIHRoZSBWTU0Kd3JpdGVzIGl0IGludG8gc29tZSBmaWxlLCB3aGVyZSBzb21lIG1vbml0b3Jp
bmcgYWdlbnQgY2FuIHBpY2sgaXQgdXAuCkluIGFueSBjYXNlLCBub3QgYWN0dWFsbHkgdHJpdmlh
bCBmcm9tIG9wcyBwZXJzcGVjdGl2ZS4KCkluIGdlbmVyYWwgSSB0ZW5kIHRvIGxpa2UgdGhlIGZk
IGFwcHJvYWNoIChldmVuIHRob3VnaCBJIGRvbid0IGxpa2UKaW9jdGxzIHZlcnkgbXVjaCAtIEkn
ZCByYXRoZXIgbGlrZSB0byBoYXZlIGl0IG1vcmUgUGxhbjktbGlrZSA7LSkpLgpCdXQgaXQgaGFz
IHRoZSBkcmF3YmFjayBvZiBhY3F1aXJpbmcgdGhvc2UgZmQncyBieSBzZXBhcmF0ZSBwcm9jZXNz
ZXMKaXNuJ3QgZW50aXJlbHkgZWFzeSBhbmQgbmVlZHMgYSBsb3Qgb2YgY29vcmRpbmF0ZWQgaW50
ZXJhY3Rpb24uCgpUaGF0IGlzc3VlIHdvdWxkIGJlIG11Y2ggZWFzaWVyIGlmIHdlIGhhZCB0aGUg
YWJpbGl0eSB0byBwdWJsaXNoCmV4aXN0aW5nIGZkJ3MgaW50byB0aGUgZmlsZSBzeXN0ZW0gKGxp
a2UgUGxhbjkncyBzcnZmcyBkb2VzKSwgYnV0IHdlCmRvbid0IGhhdmUgdGhhdCB5ZXQuIChhY3R1
YWxseSwgSSd2ZSBoYWNrZWQgdXAgc29tZSBzcnZmcyBmb3IgTGludXgsCmJ1dCAuLi4gd2VsbCAu
Li4gaXQncyBqdXN0IGEgaGFjaywgbm93aGVyZSBuZWFyIHRvIHByb2R1Y3Rpb24pLgoKV2h5IG5v
dCBwdXR0aW5nIHRoaXMgaW50byBzeXNmcyA/CgpJIHNlZSB0d28gb3B0aW9uczoKCmEpIGlmIGl0
J3MgcmVhbGx5IGt2bS1zcGVjaWZpYyAoYW5kIG5vIGNoYW5jZSBvZiB1c2luZyB0aGUgc2FtZQog
ICAgaW50ZXJmYWNlIGZvciBvdGhlciBoeXBlcnZpc29ycyksIHdlIGNvdWxkIHB1dCBpdCB1bmRl
ciB0aGUKICAgIGt2bSBkZXZpY2UgKC9zeXMvY2xhc3MvbWlzYy9rdm0pLgoKYikgaGF2ZSBhIGdl
bmVyaWMgVk1NIHN0YXRzIGludGVyZmFjZSB0aGF0IHRoZXJvcmV0aWNhbGx5IGNvdWxkIHdvcmsK
ICAgIHdpdGggYW55IGh5cGVydmlzb3IuCgoKCi0tbXR4CgotLSAKLS0tCkhpbndlaXM6IHVudmVy
c2NobMO8c3NlbHRlIEUtTWFpbHMga8O2bm5lbiBsZWljaHQgYWJnZWjDtnJ0IHVuZCBtYW5pcHVs
aWVydAp3ZXJkZW4gISBGw7xyIGVpbmUgdmVydHJhdWxpY2hlIEtvbW11bmlrYXRpb24gc2VuZGVu
IFNpZSBiaXR0ZSBpaHJlbgpHUEcvUEdQLVNjaGzDvHNzZWwgenUuCi0tLQpFbnJpY28gV2VpZ2Vs
dCwgbWV0dXggSVQgY29uc3VsdApGcmVlIHNvZnR3YXJlIGFuZCBMaW51eCBlbWJlZGRlZCBlbmdp
bmVlcmluZwppbmZvQG1ldHV4Lm5ldCAtLSArNDktMTUxLTI3NTY1Mjg3Cl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C270C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 22:14:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D28840BE7;
	Tue, 26 Apr 2022 18:14:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@samsung.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wofhn9WchIFq; Tue, 26 Apr 2022 18:14:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D49F408A7;
	Tue, 26 Apr 2022 18:14:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5F940658
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 18:14:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eXyb99F3YPUV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 18:14:36 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2970D40472
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 18:14:36 -0400 (EDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220426221434euoutp022f8b9b64da4fb570761db1e9aa6781fa~pkgHNrQ-M3036830368euoutp02V
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 22:14:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220426221434euoutp022f8b9b64da4fb570761db1e9aa6781fa~pkgHNrQ-M3036830368euoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
 s=mail20170921; t=1651011274;
 bh=IPQk0Q4k6d8MBvUz+9ejX0OyAjlYSg/gyEoYmMCjOKQ=;
 h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
 b=c89szdQsAqye3i3gDVOJO1ceZs0G4Roj86/10zF1ZeHL7T64MwRAteXyxr0pVOFL6
 5QSguS62LvxvkWerdy40ibDhR8vdLaiUdteN4DzevsNAEd3XbaVRUnE9cP6GzOloHn
 gWGi1QnvUd466neJs+QeNSvG1TbsuKTxV7Tq1Tnk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220426221434eucas1p2be4b0c6ae9323a3c69fb142dbe142e50~pkgG1t_-_1767917679eucas1p2q;
 Tue, 26 Apr 2022 22:14:34 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 46.A7.10009.ACE68626; Tue, 26
 Apr 2022 23:14:34 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220426221433eucas1p253f6350eacf87d8cac2c05adc903656e~pkgFoSNEn3138331383eucas1p2G;
 Tue, 26 Apr 2022 22:14:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220426221433eusmtrp217fa12bd618a4c127c3632bdcc4c5f61~pkgFm-M8u0332303323eusmtrp2k;
 Tue, 26 Apr 2022 22:14:33 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-51-62686ecad992
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 06.68.09404.8CE68626; Tue, 26
 Apr 2022 23:14:33 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220426221432eusmtip2bf09fbbbace97124dcdd7cd3e8aa62f7~pkgEvO3E10048000480eusmtip2h;
 Tue, 26 Apr 2022 22:14:32 +0000 (GMT)
Message-ID: <64573cca-4bd6-a65e-0ba2-867c6488e82c@samsung.com>
Date: Wed, 27 Apr 2022 00:14:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v14 27/39] arm64/sme: Provide Kconfig for SME
Content-Language: en-US
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier
 <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
 <shuah@kernel.org>
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220419112247.711548-28-broonie@kernel.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7djP87qn8jKSDDY3iVhMPGVtMX3lZTaL
 Nz0mFlMfPmGzeL+sh9Hi/r7lTBYfTx1nt9j0+BqrxfQ779kspjR3MFlMOTaF3WLnnJOsFkfW
 2ltMebmO3WLv9GWsFjNv32a0WHr8P5NFyx1TByGPNfPWMHpsWtXJ5rF/7hp2j/Ob1jB7bF5S
 7/F5k1wAWxSXTUpqTmZZapG+XQJXxv6OJ0wF8yUr9ix6ztzAeFGki5GTQ0LAROLHrOksXYxc
 HEICKxglrp49xAjhfGGUaGl/AuV8ZpQ4e+kOO0zLxz9PoVqWM0rMunuAHcL5CNSy5x0jSBWv
 gJ3EmU1tYB0sAqoS22afYYKIC0qcnPmEBcQWFUiSmLvvHnMXIweHsICjxNrP1SBhZgFxiVtP
 5jOBzBQRuMkocabxNzOIwyzwhFmi6+8NsGY2AUOJrrddbCA2p4CVxLclb5gguuUlmrfOBmuQ
 ENjMKfF8xhJmiLtdJPru9bFA2MISr45vgfpHRuL/TpB1HEB2vsTfGcYQ4QqJa6/XQLVaS9w5
 94sNpIRZQFNi/S59iGpHifffEiFMPokbbwUhDuCTmLRtOjNEmFeio00IYoaaxKzj6+BWHrxw
 iXkCo9IspDCZheT5WUhemYWwdgEjyypG8dTS4tz01GLDvNRyveLE3OLSvHS95PzcTYzAdHf6
 3/FPOxjnvvqod4iRiYPxEKMEB7OSCO89xYwkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzJmRsS
 hQTSE0tSs1NTC1KLYLJMHJxSDUx2Jn94ptr13zBOiC/KVSk3avI7vivo+zn25C87qye6VG0s
 sT33amHpBuuWRX/fW13Zv2HdhNC4vQ6vPV5cUX3yLamAb66N0plD9gxnXer/6fJVFM3h9FwT
 7GW08+KD2bMWF0RMYGTYxuX3Jaf6s7L+Xc2Az95PP+RE6Kv53mT8Oyn8yr2VPKtn+QRNO3yp
 0sVemjXqgJz4z4b+LTOX/Nms/txN+83n/I/Pw7hMLqmXhLirvGuy5Ogva3D/776i865s9I1g
 Jrt/b3SS7CMe2b6ZU3DvWlN1mpjpmfkqly+/XZM9u+zqpPAFlusaw5duuK/QuDrzq+7MANYF
 ry6czNKasbWwZ29sV0hDQOHCz7uVWIozEg21mIuKEwHziR8a5gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xe7on8zKSDH5tYrSYeMraYvrKy2wW
 b3pMLKY+fMJm8X5ZD6PF/X3LmSw+njrObrHp8TVWi+l33rNZTGnuYLKYcmwKu8XOOSdZLY6s
 tbeY8nIdu8Xe6ctYLWbevs1osfT4fyaLljumDkIea+atYfTYtKqTzWP/3DXsHuc3rWH22Lyk
 3uPzJrkAtig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9
 uwS9jP0dT5gK5ktW7Fn0nLmB8aJIFyMnh4SAicTHP09Zuhi5OIQEljJKXP4wlQkiISNxcloD
 K4QtLPHnWhcbRNF7RomP7zaxgCR4BewkzmxqYwexWQRUJbbNPsMEEReUODnzCViNqECSxItt
 zxm7GDk4hAUcJdZ+rgYJMwuIS9x6Mp8JZKaIwE1GiW39FxkhEi+YJXbeB5spJJAhcerLabA4
 m4ChRNdbkCM4OTgFrCS+LXnDBFFvJtG1tQuqV16ieets5gmMQrOQnDELyb5ZSFpmIWlZwMiy
 ilEktbQ4Nz232EivODG3uDQvXS85P3cTIzDGtx37uWUH48pXH/UOMTJxMB5ilOBgVhLhvaeY
 kSTEm5JYWZValB9fVJqTWnyI0RQYFhOZpUST84FJJq8k3tDMwNTQxMzSwNTSzFhJnNezoCNR
 SCA9sSQ1OzW1ILUIpo+Jg1OqgWn3n7UnzyUV63lOlH72pzL3x+qcqEjOE62tU/+lfJkrvutQ
 8R2fDM9sF6kPd2/zl++T0zNlU/s1V+FCNJdFWKKJ2K/bM3dcX33svO5/ndLme7zrMnzWGW/s
 qp3XbSP26lxd/O9JShqTf97q7lfJFJ19KX3J6f3VXjafP18zf/kqufZ80tSkQHf/L6+DZ7O8
 DMmZ81Kl5VUHY/WpJHEb2euru/c9m5TtcfGWlf4ChoMHlt3/s1kqzvVx35N4C9k3PG7MKrs9
 hEp+Kmzu2PNm+t4THxY/vSvcYCYya/Gx/RFzeSZw1bDN26mmeL3u8U3v/UdXTT0gPHNLTH8w
 q/6HeyxctzbPveIu87og8GLOFE4OJZbijERDLeai4kQAQLSW4XoDAAA=
X-CMS-MailID: 20220426221433eucas1p253f6350eacf87d8cac2c05adc903656e
X-Msg-Generator: CA
X-RootMTR: 20220426221433eucas1p253f6350eacf87d8cac2c05adc903656e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220426221433eucas1p253f6350eacf87d8cac2c05adc903656e
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220419112247.711548-28-broonie@kernel.org>
 <CGME20220426221433eucas1p253f6350eacf87d8cac2c05adc903656e@eucas1p2.samsung.com>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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

SGkgTWFyaywKCk9uIDE5LjA0LjIwMjIgMTM6MjIsIE1hcmsgQnJvd24gd3JvdGU6Cj4gTm93IHRo
YXQgYmFzbGluZSBzdXBwb3J0IGZvciB0aGUgU2NhbGFibGUgTWF0cml4IEV4dGVuc2lvbiAoU01F
KSBpcyBwcmVzZW50Cj4gaW50cm9kdWNlIHRoZSBLY29uZmlnIG9wdGlvbiBhbGxvd2luZyBpdCB0
byBiZSBidWlsdC4gV2hpbGUgdGhlIGZlYXR1cmUKPiByZWdpc3RlcnMgZG9uJ3QgaW1wb3NlIGEg
c3Ryb25nIHJlcXVpcmVtZW50IGZvciBhIHN5c3RlbSB3aXRoIFNNRSB0bwo+IHN1cHBvcnQgU1ZF
IGF0IHJ1bnRpbWUgdGhlIHN1cHBvcnQgZm9yIHN0cmVhbWluZyBtb2RlIFNWRSBpcyBtb3N0bHkK
PiBzaGFyZWQgd2l0aCBub3JtYWwgU1ZFIHNvIGRlcGVuZCBvbiBTVkUuCj4KPiBTaWduZWQtb2Zm
LWJ5OiBNYXJrIEJyb3duIDxicm9vbmllQGtlcm5lbC5vcmc+Cj4gUmV2aWV3ZWQtYnk6IENhdGFs
aW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+CgpUaGlzIHBhdGNoc2V0IGxhbmRl
ZCBpbiBsaW51eCBuZXh0LTIwMjIwNDI2LiBCeSBkZWZhdWx0IFNNRSBpcyBlbmFibGVkIAphbmQg
aXQgYnJlYWtzIENQVSBob3QtcGx1ZyBvbiBhbGwgbXkgYXJtNjQgdGVzdCBzeXN0ZW1zLiBCaXNl
Y3QgcG9pbnRzIAp0aGlzIHBhdGNoLCBiZWNhdXNlIGl0IGZpbmFsbHkgZW5hYmxlcyB0aGlzIGZl
YXR1cmUuIEhlcmUgaXMgYSByZXBvcnQgCmZyb20gUUVNVSdzIGFybTY0IHZpcnQgbWFjaGluZToK
CiMgZm9yIGkgaW4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1WzEtOV07IGRvIGVjaG8gMCA+
JGkvb25saW5lOyBkb25lCnBzY2k6IENQVTEga2lsbGVkIChwb2xsZWQgMCBtcykKIyBjYXQgL3By
b2MvY3B1aW5mbyB8IGdyZXAgcHJvY2Vzc29yIHwgd2MgLWwKMQojIGZvciBpIGluIC9zeXMvZGV2
aWNlcy9zeXN0ZW0vY3B1L2NwdVsxLTldOyBkbyBlY2hvIDEgPiRpL29ubGluZTsgZG9uZQotLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0Ka2VybmVsIEJVRyBhdCBhcmNoL2FybTY0
L2tlcm5lbC9jcHVmZWF0dXJlLmM6MTM1MyEKSW50ZXJuYWwgZXJyb3I6IE9vcHMgLSBCVUc6IDAg
WyMxXSBQUkVFTVBUIFNNUApNb2R1bGVzIGxpbmtlZCBpbjogYmx1ZXRvb3RoIGVjZGhfZ2VuZXJp
YyBlY2MgcmZraWxsIGlwdjYKQ1BVOiAxIFBJRDogMCBDb21tOiBzd2FwcGVyLzEgTm90IHRhaW50
ZWQgNS4xOC4wLXJjMysgIzQ4OTEKSGFyZHdhcmUgbmFtZTogbGludXgsZHVtbXktdmlydCAoRFQp
CnBzdGF0ZTogMjAwMDAxYzUgKG56Q3YgZEFJRiAtUEFOIC1VQU8gLVRDTyAtRElUIC1TU0JTIEJU
WVBFPS0tKQpwYyA6IF9fcmVhZF9zeXNyZWdfYnlfZW5jb2RpbmcrMHgzNTAvMHgzNTQKbHIgOiBo
YXNfY3B1aWRfZmVhdHVyZSsweDZjLzB4ZTAKLi4uCkNhbGwgdHJhY2U6CiDCoF9fcmVhZF9zeXNy
ZWdfYnlfZW5jb2RpbmcrMHgzNTAvMHgzNTQKIMKgaGFzX2NwdWlkX2ZlYXR1cmUrMHg2Yy8weGUw
CiDCoHZlcmlmeV9sb2NhbF9jcHVfY2FwcysweDk4LzB4MTMwCiDCoGNoZWNrX2xvY2FsX2NwdV9j
YXBhYmlsaXRpZXMrMHgyYy8weDI3MAogwqBzZWNvbmRhcnlfc3RhcnRfa2VybmVsKzB4YzAvMHgx
NzAKIMKgX19zZWNvbmRhcnlfc3dpdGNoZWQrMHhhMC8weGE0CkNvZGU6IGQ1MzgwMmQzIDE3ZmZm
ZjQ5IGQ1MzgwMjMzIDE3ZmZmZjQ3IChkNDIxMDAwMCkKLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAw
MDAwMDAwMCBdLS0tCktlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBBdHRlbXB0ZWQgdG8ga2ls
bCB0aGUgaWRsZSB0YXNrIQpTTVA6IHN0b3BwaW5nIHNlY29uZGFyeSBDUFVzCktlcm5lbCBPZmZz
ZXQ6IDB4NGU4MWZiNjAwMDAwIGZyb20gMHhmZmZmODAwMDA4MDAwMDAwClBIWVNfT0ZGU0VUOiAw
eGZmZmY5OGYyNDAwMDAwMDAKQ1BVIGZlYXR1cmVzOiAweDQ0MCwwMDAzM2MwOCwwMDAwMTA4NgpN
ZW1vcnkgTGltaXQ6IG5vbmUKLS0tWyBlbmQgS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0
dGVtcHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shIF0tLS0KCkRpc2FibGluZyBTTUUgb24gdG9w
IG9mIG5leHQtMjAyMjA0MjYgaGlkZXMgdGhpcyBpc3N1ZS4KCj4gLS0tCj4gICBhcmNoL2FybTY0
L0tjb25maWcgfCAxMSArKysrKysrKysrKwo+ICAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlv
bnMoKykKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L0tjb25maWcgYi9hcmNoL2FybTY0L0tj
b25maWcKPiBpbmRleCA1N2M0Yzk5NTk2NWYuLjA4OTc5ODQ5MThlOCAxMDA2NDQKPiAtLS0gYS9h
cmNoL2FybTY0L0tjb25maWcKPiArKysgYi9hcmNoL2FybTY0L0tjb25maWcKPiBAQCAtMTkzOSw2
ICsxOTM5LDE3IEBAIGNvbmZpZyBBUk02NF9TVkUKPiAgIAkgIGJvb3RpbmcgdGhlIGtlcm5lbC4g
IElmIHVuc3VyZSBhbmQgeW91IGFyZSBub3Qgb2JzZXJ2aW5nIHRoZXNlCj4gICAJICBzeW1wdG9t
cywgeW91IHNob3VsZCBhc3N1bWUgdGhhdCBpdCBpcyBzYWZlIHRvIHNheSBZLgo+ICAgCj4gK2Nv
bmZpZyBBUk02NF9TTUUKPiArCWJvb2wgIkFSTSBTY2FsYWJsZSBNYXRyaXggRXh0ZW5zaW9uIHN1
cHBvcnQiCj4gKwlkZWZhdWx0IHkKPiArCWRlcGVuZHMgb24gQVJNNjRfU1ZFCj4gKwloZWxwCj4g
KwkgIFRoZSBTY2FsYWJsZSBNYXRyaXggRXh0ZW5zaW9uIChTTUUpIGlzIGFuIGV4dGVuc2lvbiB0
byB0aGUgQUFyY2g2NAo+ICsJICBleGVjdXRpb24gc3RhdGUgd2hpY2ggdXRpbGlzZXMgYSBzdWJz
dGFudGlhbCBzdWJzZXQgb2YgdGhlIFNWRQo+ICsJICBpbnN0cnVjdGlvbiBzZXQsIHRvZ2V0aGVy
IHdpdGggdGhlIGFkZGl0aW9uIG9mIG5ldyBhcmNoaXRlY3R1cmFsCj4gKwkgIHJlZ2lzdGVyIHN0
YXRlIGNhcGFibGUgb2YgaG9sZGluZyB0d28gZGltZW5zaW9uYWwgbWF0cml4IHRpbGVzIHRvCj4g
KwkgIGVuYWJsZSB2YXJpb3VzIG1hdHJpeCBvcGVyYXRpb25zLgo+ICsKPiAgIGNvbmZpZyBBUk02
NF9NT0RVTEVfUExUUwo+ICAgCWJvb2wgIlVzZSBQTFRzIHRvIGFsbG93IG1vZHVsZSBtZW1vcnkg
dG8gc3BpbGwgb3ZlciBpbnRvIHZtYWxsb2MgYXJlYSIKPiAgIAlkZXBlbmRzIG9uIE1PRFVMRVMK
CkJlc3QgcmVnYXJkcwotLSAKTWFyZWsgU3p5cHJvd3NraSwgUGhEClNhbXN1bmcgUiZEIEluc3Rp
dHV0ZSBQb2xhbmQKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

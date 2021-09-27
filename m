Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679C6C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:17:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB8EC60F44
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:17:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BB8EC60F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CBCE4057F;
	Mon, 27 Sep 2021 11:17:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Dd5VLMobVdd; Mon, 27 Sep 2021 11:17:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 370E94A19F;
	Mon, 27 Sep 2021 11:17:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E93514057F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:17:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Slrogb4hpvei for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 11:17:11 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F31E84024F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:17:10 -0400 (EDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RDtpLQ005737; 
 Mon, 27 Sep 2021 11:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZEE60/MIiE9EAlUoL+qREn3xlXTzM3VY0WrkyxkxqVs=;
 b=Z/cSuPKy4WW6nyyvwgn3IEag+/NHeYMwaeEME56kq6Tji5iOugywvpgYi/UrL76eiMlQ
 rqEPuprIVzPaSCoLhjioaWlVTcIVsBDa+BA3b0xkuLj5/GnMyTHk2MNuk4ZeOpaxlIdh
 fVNQRMiw9Sx1bGglHa/7T+LtdguH++5KUhh0CKWYUckSQu30s46iS9WHlnBUJMdwW4Ng
 TPRatQYOroLn2gAkBttRiI+2eb+7Sc0GcsX/4RwXQOVsRsjZJDSIqOIhj/Z00w6+xpwf
 Qrb5Z+SFGSV0kGRWevI032kOeI59xbuvImCf0qXbfzOKh0GfkRM9ISCwmpD8AKh8rXze aw== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4y7q1-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 11:17:04 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18RCd4rR028652;
 Mon, 27 Sep 2021 11:17:02 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com
 [159.122.73.71])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bagx4y7p6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 11:17:02 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
 by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18RFDnB9014438;
 Mon, 27 Sep 2021 15:17:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
 (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
 by ppma02fra.de.ibm.com with ESMTP id 3b9ud955wc-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 27 Sep 2021 15:16:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com
 [9.149.105.58])
 by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 18RFGtkp38339018
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 27 Sep 2021 15:16:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 811A24C050;
 Mon, 27 Sep 2021 15:16:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 80DD44C04E;
 Mon, 27 Sep 2021 15:16:52 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown
 [9.171.4.236]) by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Mon, 27 Sep 2021 15:16:52 +0000 (GMT)
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
Date: Mon, 27 Sep 2021 17:16:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eb5BjgGXgLT0dQk2cLo1gGaMMdASPGv7
X-Proofpoint-ORIG-GUID: m0HV4GnBNkTGM5q4JkVIpGynJneqKgrK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_06,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 spamscore=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270103
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

CgpBbSAyNy4wOS4yMSB1bSAxNzowMyBzY2hyaWViIFBhb2xvIEJvbnppbmk6Cj4gT24gMjcvMDkv
MjEgMTY6NTksIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4+PiBjb21taXQgYWNkMDU3ODVl
NDhjMDFlZGIyYzRmNGQwMTRkMjg0NzhiNWYxOWZiNQo+Pj4gQXV0aG9yOsKgwqDCoMKgIERhdmlk
IE1hdGxhY2s8ZG1hdGxhY2tAZ29vZ2xlLmNvbT4KPj4+IEF1dGhvckRhdGU6IEZyaSBBcHIgMTcg
MTU6MTQ6NDYgMjAyMCAtMDcwMAo+Pj4gQ29tbWl0OsKgwqDCoMKgIFBhb2xvIEJvbnppbmk8cGJv
bnppbmlAcmVkaGF0LmNvbT4KPj4+IENvbW1pdERhdGU6IEZyaSBBcHIgMjQgMTI6NTM6MTcgMjAy
MCAtMDQwMAo+Pj4KPj4+IMKgwqDCoMKgIGt2bTogYWRkIGNhcGFiaWxpdHkgZm9yIGhhbHQgcG9s
bGluZwo+Pj4KPj4+IGJyb2tlIHRoZSBwb3NzaWJpbGl0eSBmb3IgYW4gYWRtaW4gdG8gZGlzYWJs
ZSBoYWx0IHBvbGxpbmcgZm9yIGFscmVhZHkgcnVubmluZyBLVk0gZ3Vlc3RzLgo+Pj4gSW4gcGFz
dCB0aW1lcyBkb2luZwo+Pj4gZWNobyAwID4gL3N5cy9tb2R1bGUva3ZtL3BhcmFtZXRlcnMvaGFs
dF9wb2xsX25zCj4+Pgo+Pj4gc3RvcHBlZCBwb2xsaW5nIHN5c3RlbSB3aWRlLgo+Pj4gTm93IGFs
bCBLVk0gZ3Vlc3RzIHdpbGwgdXNlIHRoZSBoYWx0X3BvbGxfbnMgdmFsdWUgdGhhdCB3YXMgYWN0
aXZlIGR1cmluZwo+Pj4gc3RhcnR1cCAtIGV2ZW4gdGhvc2UgdGhhdCBkbyBub3QgdXNlIEtWTV9D
QVBfSEFMVF9QT0xMLgo+Pj4KPj4+IEkgZ3Vlc3MgdGhpcyB3YXMgbm90IGludGVuZGVkPwo+IAo+
IE5vLCBidXQuLi4KPiAKPj4gSSB3b3VsZCBnbyBzbyBmYXIgYXMgdG8gc2F5IHRoYXQgaGFsdF9w
b2xsX25zIHNob3VsZCBiZSBhIGhhcmQgbGltaXQgb24KPj4gdGhlIGNhcGFiaWxpdHkKPiAKPiAu
Li4gdGhpcyB3b3VsZCBub3QgYmUgYSBnb29kIGlkZWEgSSB0aGluay7CoCBBbnl0aGluZyB0aGF0
IHdhbnRzIHRvIGRvIGEgbG90IG9mIHBvbGxpbmcgY2FuIGp1c3QgZG8gImZvciAoOzspIi4KPiAK
PiBTbyBJIHRoaW5rIHRoZXJlIGFyZSB0d28gcG9zc2liaWxpdGllcyB0aGF0IG1ha2VzIHNlbnNl
Ogo+IAo+ICogdHJhY2sgd2hhdCBpcyB1c2luZyBLVk1fQ0FQX0hBTFRfUE9MTCwgYW5kIG1ha2Ug
d3JpdGVzIHRvIGhhbHRfcG9sbF9ucyBmb2xsb3cgdGhhdAoKd2hhdCBhYm91dCB1c2luZyBoYWx0
X3BvbGxfbnMgZm9yIHRob3NlIFZNcyB0aGF0IGRpZCBub3QgdXNlcyBLVk1fQ0FQX0hBTFRfUE9M
TCBhbmQgdGhlIHByaXZhdGUgbnVtYmVyIGZvciB0aG9zZSB0aGF0IGRpZC4KPiAKPiAqIGp1c3Qg
bWFrZSBoYWx0X3BvbGxfbnMgcmVhZC1vbmx5Lgo+IAo+IFBhb2xvCj4gCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

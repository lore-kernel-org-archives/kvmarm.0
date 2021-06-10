Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833B4C48BCD
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:53:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA9BD613E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 06:53:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA9BD613E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61072407EF;
	Thu, 10 Jun 2021 02:53:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DhbxXOMPl98I; Thu, 10 Jun 2021 02:53:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C65C4086A;
	Thu, 10 Jun 2021 02:53:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3DA5407EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:53:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ihX-y6+1iOYA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 02:53:51 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0326340617
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 02:53:50 -0400 (EDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
 15A6XFRe179803; Thu, 10 Jun 2021 02:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Zpyy7GdEdJB+ws0/NSpA6v98MDlU7R6ucXpSF+9fNkE=;
 b=HYRriYwRoKCguEqNgUZ14OUrgnXBJEpiJ/5jkbnzi7KmIMbm4pWDi4cj7H8++0ZwL9HQ
 1zqNWCKFz6faxWv2F1paNDVfsyhbVS2ifa0jPGdmQNS8QalpZcn4J9iqoQJftxz2V1Bk
 XJb9jHG+jYh4ctUKGxdQu+sTj9rJ0LZyz6cRq2rv7hYe4v1YtDISMaGXW2Cl3EJCyqJu
 JMp95V/GhjeOh7o/X1gqv2GdIU7BHnzqW9VxkCjpJlJU9yNoAC2m6x7fBfth47GauTeJ
 9rnGBd1AFnUtsr2PRDQQ34UjYqpiBWROdeRCRiFDUFGqK1bOiPwBM8JR+lJUgVdNtnVt mA== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0b-001b2d01.pphosted.com with ESMTP id 393c29tm06-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 10 Jun 2021 02:53:49 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15A6XVfu180452;
 Thu, 10 Jun 2021 02:53:48 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com
 [159.122.73.70])
 by mx0b-001b2d01.pphosted.com with ESMTP id 393c29tkyn-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 10 Jun 2021 02:53:48 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
 by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15A6prLS003304;
 Thu, 10 Jun 2021 06:53:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by ppma01fra.de.ibm.com with ESMTP id 3936ns02xy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 10 Jun 2021 06:53:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
 [9.149.105.62])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 15A6rieP31130102
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 10 Jun 2021 06:53:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 66BB5AE051;
 Thu, 10 Jun 2021 06:53:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id BED54AE053;
 Thu, 10 Jun 2021 06:53:43 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.13.5])
 by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Thu, 10 Jun 2021 06:53:43 +0000 (GMT)
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
To: Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oupton@google.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
 <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
 <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
 <7b57ce79-6a17-70ac-4639-47a0df463e49@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <a3754185-ad03-c20d-d3df-9ddfd0187c99@de.ibm.com>
Date: Thu, 10 Jun 2021 08:53:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <7b57ce79-6a17-70ac-4639-47a0df463e49@redhat.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d2yPKyqtH_-uvpCfYSewkVKVe2Ifw3Od
X-Proofpoint-ORIG-GUID: 1uBaAxvYHv7HwtGU5kMIO2iNMoRh2MET
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.761
 definitions=2021-06-10_03:2021-06-10,
 2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100041
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

CgpPbiAxMC4wNi4yMSAwODoyMiwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiAxMC8wNi8yMSAw
MDowNCwgT2xpdmVyIFVwdG9uIHdyb3RlOgo+Pj4gWW91ciBhcHByb2FjaCBzdGlsbCBuZWVkcyB0
byB1c2UgdGhlICJxdWlya3kiIGFwcHJvYWNoIHRvIGhvc3QtaW5pdGlhdGVkCj4+PiBNU1JfSUEz
Ml9UU0NfQURKVVNUIHdyaXRlcywgd2hpY2ggd3JpdGUgdGhlIE1TUiB3aXRob3V0IGFmZmVjdGlu
ZyB0aGUKPj4+IFZNQ1Mgb2Zmc2V0LsKgIFRoaXMgaXMganVzdCBhIGRvY3VtZW50YXRpb24gaXNz
dWUuCj4+Cj4+IE15IHN1Z2dlc3RlZCBpb2N0bCBmb3IgdGhlIHZDUFUgd2lsbCBzdGlsbCBleGlz
dCwgYW5kIGl0IHdpbGwgc3RpbGwKPj4gYWZmZWN0IHRoZSBWTUNTIHRzYyBvZmZzZXQsIHJpZ2h0
PyBIb3dldmVyLCB3ZSBuZWVkIHRvIGRvIG9uZSBvZiB0aGUKPj4gZm9sbG93aW5nOgo+Pgo+PiAt
IFN0YXNoIHRoZSBndWVzdCdzIE1TUl9JQTMyX1RTQ19BREpVU1QgdmFsdWUgaW4gdGhlCj4+IGt2
bV9zeXN0ZW1fY291bnRlcl9zdGF0ZSBzdHJ1Y3R1cmUuIER1cmluZwo+PiBLVk1fU0VUX1NZU1RF
TV9DT1VOVEVSX1NUQVRFLCBjaGVjayB0byBzZWUgaWYgdGhlIGZpZWxkIGlzIHZhbGlkLiBJZgo+
PiBzbywgdHJlYXQgaXQgYXMgYSBkdW1iIHZhbHVlIChpLmUuIHNob3cgaXQgdG8gdGhlIGd1ZXN0
IGJ1dCBkb24ndCBmb2xkCj4+IGl0IGludG8gdGhlIG9mZnNldCkuCj4gCj4gWWVzLCBpdCdzIGFs
cmVhZHkgZm9sZGVkIGludG8gdGhlIGd1ZXN0VFNDLWhvc3RUU0Mgb2Zmc2V0IHRoYXQgdGhlIGNh
bGxlciBwcm92aWRlcy4KPiAKPj4gLSBJbmZvcm0gdXNlcnNwYWNlIHRoYXQgaXQgbXVzdCBzdGls
bCBtaWdyYXRlIE1TUl9JQTMyX1RTQ19BREpVU1QsIGFuZAo+PiBjb250aW51ZSB0byBvdXIgcXVp
cmt5IGJlaGF2aW9yIGFyb3VuZCBob3N0LWluaXRpYXRlZCB3cml0ZXMgb2YgdGhlCj4+IE1TUi4K
Pj4KPj4gVGhpcyBpcyB3aHkgTWF4aW0ncyBzcGluIG1pZ3JhdGVkIGEgdmFsdWUgZm9yIElBMzJf
VFNDX0FESlVTVCwgcmlnaHQ/Cj4gCj4gWWVzLCBzbyB0aGF0IGhlIGNvdWxkIHRoZW4gcmVtb3Zl
IChvcHRpb25hbGx5KSB0aGUgcXVpcmsgZm9yIGhvc3QtaW5pdGlhdGVkIHdyaXRlcyB0byB0aGUg
VFNDIGFuZCBUU0NfQURKVVNUIE1TUnMuCj4gCj4+IERvaW5nIHNvIGVuc3VyZXMgd2UgZG9uJ3Qg
aGF2ZSBhbnkgZ3Vlc3Qtb2JzZXJ2YWJsZSBjb25zZXF1ZW5jZXMgZHVlCj4+IHRvIG91ciBtaWdy
YXRpb24gb2YgVFNDIHN0YXRlLiBUbyBtZSwgYWRkaW5nIHRoZSBndWVzdCBJQTMyX1RTQ19BREpV
U1QKPj4gTVNSIGludG8gdGhlIG5ldyBjb3VudGVyIHN0YXRlIHN0cnVjdHVyZSBpcyBwcm9iYWJs
eSBiZXN0LiBObyBzdHJvbmcKPj4gb3BpbmlvbnMgaW4gZWl0aGVyIGRpcmVjdGlvbiBvbiB0aGlz
IHBvaW50LCB0aG91Z2g6KQo+IAo+IEVpdGhlciBpcyBnb29kIGZvciBtZSwgc2luY2UgZG9jdW1l
bnRhdGlvbiB3aWxsIGJlIHZlcnkgaW1wb3J0YW50IGVpdGhlciB3YXkuwqAgVGhpcyBpcyBhIGNv
bXBsZXggQVBJIHRvIHVzZSBkdWUgdG8gdGhlIHBvc3NpYmlsaXR5IG9mIHNrZXdlZCBUU0NzLgo+
IAo+IEp1c3Qgb25lIHRoaW5nLCBwbGVhc2UgZG9uJ3QgaW50cm9kdWNlIGEgbmV3IGlvY3RsIGFu
ZCB1c2UgS1ZNX0dFVF9ERVZJQ0VfQVRUUi9LVk1fU0VUX0RFVklDRV9BVFRSL0tWTV9IQVNfREVW
SUNFX0FUVFIuCj4gCj4gQ2hyaXN0aWFuLCBiYXNlZCBvbiB3aGF0IE9saXZlciBtZW50aW9ucyBo
ZXJlLCBpdCdzIHByb2JhYmx5IHVzZWZ1bCBmb3IgczM5MCB0byBoYXZlIGZ1bmN0aW9uYWxpdHkg
dG8gZ2V0L3NldCBrdm0tPmFyY2guZXBvY2ggYW5kIGt2bS0+YXJjaC5lcGR4IGluIGFkZGl0aW9u
IHRvIHRoZSBhYnNvbHV0ZSBUT0QgdmFsdWVzIHRoYXQgeW91IGFyZSBtaWdyYXRpbmcgbm93LgoK
WWVzLCBhIHNjaGVtZSB3aGVyZSB3ZSBtaWdyYXRlIHRoZSBvZmZzZXRzIChhc3N1bWluZyB0aGF0
IHRoZSBob3N0cyBhcmUgc3luY2VkKSB3b3VsZCBiZSBvZnRlbiBiZXR0ZXIuCklmIHRoZSBob3N0
cyBhcmUgbm90IHN5bmNlZCwgdGhpbmdzIHdpbGwgYmUgaGFyZGVyLiBJIHdpbGwgaGF2ZSBhIGxv
b2sgYXQgdGhpcyBzZXJpZXMsIFRoYW5rcyBmb3IgdGhlIHBvaW50ZXIuCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=

Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1C7C4321E
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09FAB4BAE4;
	Thu, 10 Nov 2022 09:52:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Opy4SllTrYij; Thu, 10 Nov 2022 09:51:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D67994BB47;
	Thu, 10 Nov 2022 09:51:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7644B812
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 14:09:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DvFsMGqUMoh8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 14:09:14 -0500 (EST)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CC4E4B845
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 14:09:14 -0500 (EST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7IMGET008477;
 Mon, 7 Nov 2022 19:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8yB1T9kkcj6JZp4TFm1A7hnrKTeQoKKGrd8tbPdyOEs=;
 b=mPK9o5wVItAdUCHHrTW+8HPUpMJmXCn685NlXKeVscLMgyHN4njk8bVPEIHZQPcPLZqK
 Ztz8RCrPoADtS/PrmmIEoIPAMygo0OG+ehIy/Xh5qIWr83a/qhrmNPRWHT7LucYzuM6v
 GRY8EZO5Yi9cBmIGqjDcuXfelRLAZTOy12d0YJGmmFC79SKpFsiYDDpFKy4ciSN4pXgq
 ZH3CiU5g+v8IvCRrWHCXajaSzXembp+poMANK9d6PkKxLctLIG6WcGSnTwltbKhrZ/q9
 fu9tqSDViuxcUkN+0hEHKxNVgqwvD3l/8QHsqgCbXQ/CCD24BS1R0u7ACKjl2l8sEdL4 +A== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1vspb26-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 19:08:57 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7IgUpc024059;
 Mon, 7 Nov 2022 19:08:56 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com
 [169.55.85.253])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1vspb1g-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 19:08:56 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
 by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7J6ZLd012249;
 Mon, 7 Nov 2022 19:08:55 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com
 [9.57.198.24]) by ppma01wdc.us.ibm.com with ESMTP id 3kngs3smh7-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 07 Nov 2022 19:08:55 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
 by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 2A7J8sh916712426
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 7 Nov 2022 19:08:54 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 26BC558068;
 Mon,  7 Nov 2022 19:08:54 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 430D958060;
 Mon,  7 Nov 2022 19:08:50 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown
 [9.65.225.56]) by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
 Mon,  7 Nov 2022 19:08:50 +0000 (GMT)
Message-ID: <13c194d02d02a0e2adc006c724809b63c11f1e80.camel@linux.ibm.com>
Subject: Re: [PATCH 30/44] KVM: Drop kvm_arch_check_processor_compat() hook
From: Eric Farman <farman@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Matthew Rosato
 <mjrosato@linux.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Mon, 07 Nov 2022 14:08:47 -0500
In-Reply-To: <20221102231911.3107438-31-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-31-seanjc@google.com>
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RHHp999uHGQe6ZCvMSlBReRcUeSiiV8m
X-Proofpoint-GUID: DuaePqxTnOnEid3ZLdZuErIqRkSISZr5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_09,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 mlxlogscore=793
 phishscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070152
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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

T24gV2VkLCAyMDIyLTExLTAyIGF0IDIzOjE4ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOgo+IERyb3Aga3ZtX2FyY2hfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdCgpIGFuZCBpdHMgc3Vw
cG9ydCBjb2RlIG5vdyB0aGF0Cj4gYWxsCj4gYXJjaGl0ZWN0dXJlIGltcGxlbWVudGF0aW9ucyBh
cmUgbm9wcy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNA
Z29vZ2xlLmNvbT4KPiAtLS0KPiDCoGFyY2gvYXJtNjQva3ZtL2FybS5jwqDCoMKgwqDCoMKgIHzC
oCA3ICstLS0tLS0KPiDCoGFyY2gvbWlwcy9rdm0vbWlwcy5jwqDCoMKgwqDCoMKgIHzCoCA3ICst
LS0tLS0KPiDCoGFyY2gvcG93ZXJwYy9rdm0vYm9vazNzLmPCoCB8wqAgMiArLQo+IMKgYXJjaC9w
b3dlcnBjL2t2bS9lNTAwLmPCoMKgwqAgfMKgIDIgKy0KPiDCoGFyY2gvcG93ZXJwYy9rdm0vZTUw
MG1jLmPCoCB8wqAgMiArLQo+IMKgYXJjaC9wb3dlcnBjL2t2bS9wb3dlcnBjLmMgfMKgIDUgLS0t
LS0KPiDCoGFyY2gvcmlzY3Yva3ZtL21haW4uY8KgwqDCoMKgwqAgfMKgIDcgKy0tLS0tLQo+IMKg
YXJjaC9zMzkwL2t2bS9rdm0tczM5MC5jwqDCoCB8wqAgNyArLS0tLS0tCj4gwqBhcmNoL3g4Ni9r
dm0vc3ZtL3N2bS5jwqDCoMKgwqAgfMKgIDQgKystLQo+IMKgYXJjaC94ODYva3ZtL3ZteC92bXgu
Y8KgwqDCoMKgIHzCoCA0ICsrLS0KPiDCoGFyY2gveDg2L2t2bS94ODYuY8KgwqDCoMKgwqDCoMKg
wqAgfMKgIDUgLS0tLS0KPiDCoGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaMKgwqAgfMKgIDQgKy0t
LQo+IMKgdmlydC9rdm0va3ZtX21haW4uY8KgwqDCoMKgwqDCoMKgIHwgMjQgKy0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCj4gwqAxMyBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCA2NyBk
ZWxldGlvbnMoLSkKClJldmlld2VkLWJ5OiBFcmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5j
b20+CSMgczM5MApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K

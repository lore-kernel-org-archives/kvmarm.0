Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6701AC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 16:58:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213B14A1B0;
	Thu,  3 Nov 2022 12:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CJUo8pb9CLlI; Thu,  3 Nov 2022 12:58:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD27F4B74E;
	Thu,  3 Nov 2022 12:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2554B5F5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 08:08:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k2h810LhIxCe for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 08:08:41 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 877A240801
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 08:08:41 -0400 (EDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3B0Gq9021170;
 Thu, 3 Nov 2022 12:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tRd+Sf4ESzYxXeduPYDhAWunMH0Pov2R0lxSdKxbbNc=;
 b=VRfTy5Inlafk+/Jp+RulvFawqvi/rSVV5WzgD4Q1ylYH5YYV6rkSt9im3XzzAdVhyA1S
 pvZsUgzws4pR0NmM9t9h3jocHcktl8DGqfhgFSLrxlknEcccU5fUwG0weOUeZmhOa+v5
 /TFIiNm4imhOJWsZbUA3gE1G3WJq3v1g1w94vinZPPz+bPMUjHFVAQVWDh4M5o1yB8nr
 CkL0Og3cF1BgO+0JO95fWHkydv9kJ87DI6b+gpdqCKQU6YCXb72iPx1NOlLixNYoO4Le
 By84c4Q99oNNnMAvCX2FNua/g8RbEyUfgdWXfOnEc+5/w1mAKOkACyhntrGE3j92Ekby jg== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3km6pgvku9-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 03 Nov 2022 12:08:11 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3Aw71f011008;
 Thu, 3 Nov 2022 12:08:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.98])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3km6pgvksp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 03 Nov 2022 12:08:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
 by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3C5slO006357;
 Thu, 3 Nov 2022 12:08:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
 (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
 by ppma03ams.nl.ibm.com with ESMTP id 3kgut90qww-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 03 Nov 2022 12:08:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
 [9.149.105.61])
 by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP
 id 2A3C2WEU47645072
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 3 Nov 2022 12:02:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 7331F11C050;
 Thu,  3 Nov 2022 12:08:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 019D711C04A;
 Thu,  3 Nov 2022 12:08:03 +0000 (GMT)
Received: from [9.179.10.27] (unknown [9.179.10.27])
 by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Thu,  3 Nov 2022 12:08:02 +0000 (GMT)
Message-ID: <b37267a9-c0b4-9841-71af-d8eab9baeb60@linux.ibm.com>
Date: Thu, 3 Nov 2022 13:08:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221102231911.3107438-1-seanjc@google.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kDz4IlUkdMl5dt80_ZCu6z1wzI39hakX
X-Proofpoint-GUID: KA9oP9_xjNfF3-IlHpu6OGKikLeeqdHZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030083
X-Mailman-Approved-At: Thu, 03 Nov 2022 12:58:44 -0400
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Am 03.11.22 um 00:18 schrieb Sean Christopherson:
> Non-x86 folks, please test on hardware when possible.  I made a _lot_ of
> mistakes when moving code around.  Thankfully, x86 was the trickiest code
> to deal with, and I'm fairly confident that I found all the bugs I
> introduced via testing.  But the number of mistakes I made and found on
> x86 makes me more than a bit worried that I screwed something up in other
> arch code.
> 
> This is a continuation of Chao's series to do x86 CPU compatibility checks
> during virtualization hardware enabling[1], and of Isaku's series to try
> and clean up the hardware enabling paths so that x86 (Intel specifically)
> can temporarily enable hardware during module initialization without
> causing undue pain for other architectures[2].  It also includes one patch
> from another mini-series from Isaku that provides the less controversial
> patches[3].
> 
> The main theme of this series is to kill off kvm_arch_init(),
> kvm_arch_hardware_(un)setup(), and kvm_arch_check_processor_compat(), which
> all originated in x86 code from way back when, and needlessly complicate
> both common KVM code and architecture code.  E.g. many architectures don't
> mark functions/data as __init/__ro_after_init purely because kvm_init()
> isn't marked __init to support x86's separate vendor modules.
> 
> The idea/hope is that with those hooks gone (moved to arch code), it will
> be easier for x86 (and other architectures) to modify their module init
> sequences as needed without having to fight common KVM code.  E.g. I'm
> hoping that ARM can build on this to simplify its hardware enabling logic,
> especially the pKVM side of things.
> 
> There are bug fixes throughout this series.  They are more scattered than
> I would usually prefer, but getting the sequencing correct was a gigantic
> pain for many of the x86 fixes due to needing to fix common code in order
> for the x86 fix to have any meaning.  And while the bugs are often fatal,
> they aren't all that interesting for most users as they either require a
> malicious admin or broken hardware, i.e. aren't likely to be encountered
> by the vast majority of KVM users.  So unless someone _really_ wants a
> particular fix isolated for backporting, I'm not planning on shuffling
> patches.
> 
> Tested on x86.  Lightly tested on arm64.  Compile tested only on all other
> architectures.

Some sniff tests seem to work ok on s390.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Return-Path: <SRS0=G0pq=PO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3DAC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Oct 2021 18:30:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF10861078
	for <kvmarm@archiver.kernel.org>; Tue, 26 Oct 2021 18:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF10861078
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BDD54B0D9;
	Tue, 26 Oct 2021 14:30:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QksrVwob9CPE; Tue, 26 Oct 2021 14:30:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 886FF4B0E2;
	Tue, 26 Oct 2021 14:30:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AC5C4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 14:30:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o0-g+ME8+KRM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Oct 2021 14:30:12 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CAE640068
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Oct 2021 14:30:12 -0400 (EDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QG1oc7035894; 
 Tue, 26 Oct 2021 18:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kHQsUpw1VFu+TXvR3qH68hSJpP0tEJmquXEf/hWANuE=;
 b=CPpIaKBG5Tl8Nl3RLSocczn2e8RIBD3cyDKfpQKhgmH3lYN567yvuqbL3znAzcpdm4ti
 +sI2leQ/S1XFZfyR+1sYEKoec8tqsk19fXLH6BPQXoH+ldOrcrHkmaAZnr+JApFBwYRp
 4sjv/kz5ZsR18O/340unhMQKEZN4OkrBfeJPG5JSs5pALT1+muGdPkwwMcdDY6E4SGPm
 YLpI7hwmH2WU7b1/5zY9Qeou3Mq+oGfct+1/1hv6Bsw7L8lO4x4xDZikTzHTcabU31Cx
 SC4DHiMuIgtNdCgOl3wDEHJykcXDGttiQ8w+GW1b+HFudewIMM29Nhg9Qke/YVSLCgj3 xA== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4kbhr58-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Tue, 26 Oct 2021 18:30:05 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19QIBbd0034899;
 Tue, 26 Oct 2021 18:30:05 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com
 [149.81.74.106])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bx4kbhr3x-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Tue, 26 Oct 2021 18:30:04 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
 by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19QIHPAD028495;
 Tue, 26 Oct 2021 18:30:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
 (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
 by ppma04fra.de.ibm.com with ESMTP id 3bx4f7fm39-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Tue, 26 Oct 2021 18:30:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
 [9.149.105.61])
 by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 19QITxnK51249440
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 26 Oct 2021 18:29:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 360B811C052;
 Tue, 26 Oct 2021 18:29:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id DC53C11C050;
 Tue, 26 Oct 2021 18:29:57 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown
 [9.171.78.157])
 by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Tue, 26 Oct 2021 18:29:57 +0000 (GMT)
Subject: Re: [PATCH v2 00/43] KVM: Halt-polling and x86 APICv overhaul
To: Sean Christopherson <seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <04b1a72e-47b4-4bde-eb9e-ba36c156ff0d@de.ibm.com>
 <YXgVIvYhABnrP2Jo@google.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <a9c1e6ca-0257-4b69-84dd-49d3485f9565@de.ibm.com>
Date: Tue, 26 Oct 2021 20:29:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXgVIvYhABnrP2Jo@google.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JmDEkCgcD3-ZRJi2Qd_r_hCC449htTWY
X-Proofpoint-GUID: 02zJ-KDhJ3N2JI7UDwO_ZOcNKnXzVG1F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=966 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260100
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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



Am 26.10.21 um 16:48 schrieb Sean Christopherson:
> On Tue, Oct 26, 2021, Christian Borntraeger wrote:
>> Am 09.10.21 um 04:11 schrieb Sean Christopherson:
>>> This is basically two series smushed into one.  The first "half" aims
>>> to differentiate between "halt" and a more generic "block", where "halt"
>>> aligns with x86's HLT instruction, the halt-polling mechanisms, and
>>> associated stats, and "block" means any guest action that causes the vCPU
>>> to block/wait.
>>>
>>> The second "half" overhauls x86's APIC virtualization code (Posted
>>> Interrupts on Intel VMX, AVIC on AMD SVM) to do their updates in response
>>> to vCPU (un)blocking in the vcpu_load/put() paths, keying off of the
>>> vCPU's rcuwait status to determine when a blocking vCPU is being put and
>>> reloaded.  This idea comes from arm64's kvm_timer_vcpu_put(), which I
>>> stumbled across when diving into the history of arm64's (un)blocking hooks.
>>>
>>> The x86 APICv overhaul allows for killing off several sets of hooks in
>>> common KVM and in x86 KVM (to the vendor code).  Moving everything to
>>> vcpu_put/load() also realizes nice cleanups, especially for the Posted
>>> Interrupt code, which required some impressive mental gymnastics to
>>> understand how vCPU task migration interacted with vCPU blocking.
>>>
>>> Non-x86 folks, sorry for the noise.  I'm hoping the common parts can get
>>> applied without much fuss so that future versions can be x86-only.
>>>
>>> v2:
>>>    - Collect reviews. [Christian, David]
>>>    - Add patch to move arm64 WFI functionality out of hooks. [Marc]
>>>    - Add RISC-V to the fun.
>>>    - Add all the APICv fun.
>>
>> Have we actually followed up on the regression regarding halt_poll_ns=0 no longer disabling
>> polling for running systems?
> 
> No, I have that conversation flagged but haven't gotten back to it.  I still like
> the idea of special casing halt_poll_ns=0 to override the capability.  I can send
> a proper patch for that unless there's a different/better idea?

I think I would prefer a variant that uses the halt_poll_ns value AS IS for all
guests that have not opted in the per guest feature.
And then MAYBE have 0 as a special case to disable that also for the opted in
VMs.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

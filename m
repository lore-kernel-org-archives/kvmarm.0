Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E222C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 06:57:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 052AA611C0
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 06:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 052AA611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=de.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59EA94B0DE;
	Wed, 29 Sep 2021 02:57:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ugifS-kapQlF; Wed, 29 Sep 2021 02:57:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 143444B086;
	Wed, 29 Sep 2021 02:57:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BC024086D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 02:57:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QyH3482h5RZQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 02:57:06 -0400 (EDT)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BB8740762
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 02:57:06 -0400 (EDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T5SkVo022659; 
 Wed, 29 Sep 2021 02:57:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Yeu3khHTm5BupXM7O0QrFwzJN1blGbA0zJSQEfZsP6w=;
 b=Kdjclkf7M3yIt4TgwLA0CDrQVxbB9lQXRk6NU5oMIkWijuVNijCDFlohxJ1bqF/n10Ms
 zbNo2ZzwcMGfSAUsZsxilnklDSay4eXI+0K1wbkiW3LnU83/If3DgfeYyIfIpsKs3ve0
 fyEDGHnHMxvocZ84XnUC+eaADB9nooNU4bojiMygTBnd3Rc8tb62dOoZdpaF+BIqtH2X
 vRgUg8wEO9rvnY86Nfx4eap52M53/ojKPlZa2kGqar+SFg/xO84NLCD8uQA2aMnRNU0r
 s/cLIQrKVXV231iG5rpz7g9fUGwmAnZUpmzyDRCSOSDYVuYk8pe9GUAMhdTzl3jvNdpz KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bcj1k1pdv-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 29 Sep 2021 02:57:00 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18T6VVRm004893;
 Wed, 29 Sep 2021 02:56:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 3bcj1k1pd3-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 29 Sep 2021 02:56:58 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
 by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18T6pPq5021643;
 Wed, 29 Sep 2021 06:56:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
 (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
 by ppma04ams.nl.ibm.com with ESMTP id 3b9ud9vjg6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 29 Sep 2021 06:56:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com
 [9.149.105.59])
 by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 18T6uql7066264
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 29 Sep 2021 06:56:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id ADD5CA4055;
 Wed, 29 Sep 2021 06:56:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 0A55DA4057;
 Wed, 29 Sep 2021 06:56:51 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown
 [9.171.68.197])
 by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
 Wed, 29 Sep 2021 06:56:50 +0000 (GMT)
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To: David Matlack <dmatlack@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
 <CALzav=cxeYieTkKJhT0kFZOjdv6k5eCZXKWs=ZQGCJg0x-oFjQ@mail.gmail.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <c64d0810-3563-928e-55c1-e50da8639808@de.ibm.com>
Date: Wed, 29 Sep 2021 08:56:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CALzav=cxeYieTkKJhT0kFZOjdv6k5eCZXKWs=ZQGCJg0x-oFjQ@mail.gmail.com>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oGT42cAErGJFR7G6oCrTzoCuADqRL6rZ
X-Proofpoint-ORIG-GUID: eXsFnYoOLfQdZT2uYY5Pes1aFc7SZbXJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_02,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290038
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm list <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
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



Am 27.09.21 um 18:58 schrieb David Matlack:
> On Mon, Sep 27, 2021 at 8:17 AM Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>>
>>
>>
>> Am 27.09.21 um 17:03 schrieb Paolo Bonzini:
>>> On 27/09/21 16:59, Sean Christopherson wrote:
>>>>> commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
>>>>> Author:     David Matlack<dmatlack@google.com>
>>>>> AuthorDate: Fri Apr 17 15:14:46 2020 -0700
>>>>> Commit:     Paolo Bonzini<pbonzini@redhat.com>
>>>>> CommitDate: Fri Apr 24 12:53:17 2020 -0400
>>>>>
>>>>>       kvm: add capability for halt polling
>>>>>
>>>>> broke the possibility for an admin to disable halt polling for already running KVM guests.
>>>>> In past times doing
>>>>> echo 0 > /sys/module/kvm/parameters/halt_poll_ns
>>>>>
>>>>> stopped polling system wide.
>>>>> Now all KVM guests will use the halt_poll_ns value that was active during
>>>>> startup - even those that do not use KVM_CAP_HALT_POLL.
>>>>>
>>>>> I guess this was not intended?
>>>
>>> No, but...
>>>
>>>> I would go so far as to say that halt_poll_ns should be a hard limit on
>>>> the capability
>>>
>>> ... this would not be a good idea I think.  Anything that wants to do a lot of polling can just do "for (;;)".
> 
> I agree. It would also be a maintenance burden and subtle "gotcha" to
> have to increase halt_poll_ns anytime one wants to increase
> KVM_CAP_HALT_POLL.

I think the idea of the upper bound is not about preventing wasting CPUs
but to reconfigure existing poll intervals on a global level. So I think
this idea is a bad idea in itself. Especially as the admin might not have
access to the monitor of user QEMUs.

>>>
>>> So I think there are two possibilities that makes sense:
>>>
>>> * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
>>
>> what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.
> 
> None of these options would cover Christian's original use-case
> though. (Write to module to disable halt-polling system-wide.)
> 
> What about adding a writable "enable_halt_polling" module parameter

that would then affect both classes with and without KVM_CAP_HALT_POLL.

> that affects all VMs? Once that is in place we could also consider
> getting rid of halt_poll_ns entirely.

As far as I can tell QEMU does not yet use KVM_CAP_HALT_POLL.
So having a system wide halt_poll_ns makes sense. And I think for all
processes not using KVM_CAP_HALT_POLL we should really follow what
halt_poll_ns is NOW and not what it used to be.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

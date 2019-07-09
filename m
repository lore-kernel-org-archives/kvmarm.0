Return-Path: <SRS0=/6PO=VG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B09C73C53
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 19:07:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F403A2082A
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jul 2019 19:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="4yCSg4XW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F403A2082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BEBE4A503;
	Tue,  9 Jul 2019 15:07:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qC1SyD0W3O9r; Tue,  9 Jul 2019 15:07:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2033B4A544;
	Tue,  9 Jul 2019 15:07:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 580FE4A503
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 15:07:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S1kFzNo0XXST for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jul 2019 15:07:04 -0400 (EDT)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F21D94A502
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jul 2019 15:07:03 -0400 (EDT)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
 by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69J46u1188721;
 Tue, 9 Jul 2019 19:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Yv+yrBeYqVkGCt6LLOk5beU+S3/T8S7t8pToxYNFrvA=;
 b=4yCSg4XWjehbQ+4vOWcfPZ8mTO11RReysfIntOl88QF69DGa5deUYpF9+QgwBEwJ34EI
 gocSLnUM0idJqrKQOjf9egsxG00NemUDBqrkIuFhJNefyMAaN5TRSSPnrA7FjspzSkWn
 BPZJDO/V6dcyf79+yEgzcZo3A2yyaSPKkHzkR9RAaWcilWXtupRah7XberXC5nNvQ40b
 3+Sh3WNOLn0SH/cXQ6kh4EzeubRnu7ylogU2nlYPrJm18OmQL/IyHw66ZJ1hZPqYlJs4
 MIQCnAlADG2JrhpwoegQ4WUvijFEFvtX+0pRHuRLDr7YiSrBs9S0FlczRyFpH0vJQnPs Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
 by userp2120.oracle.com with ESMTP id 2tjm9qp3q2-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Jul 2019 19:06:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
 by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69IvwWt190370;
 Tue, 9 Jul 2019 19:06:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
 by userp3030.oracle.com with ESMTP id 2tjgru9d9c-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 09 Jul 2019 19:06:51 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
 by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x69J6lep030169;
 Tue, 9 Jul 2019 19:06:48 GMT
Received: from [10.159.233.89] (/10.159.233.89)
 by default (Oracle Beehive Gateway v4.0)
 with ESMTP ; Tue, 09 Jul 2019 12:06:47 -0700
Subject: Re: [RFC PATCH v2 0/3] Support CPU hotplug for ARM64
To: James Morse <james.morse@arm.com>,
 Xiongfeng Wang <wangxiongfeng2@huawei.com>
References: <1561776155-38975-1-git-send-email-wangxiongfeng2@huawei.com>
 <82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com>
From: Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <51cc9a5c-9968-c4b1-0bc7-870f44a3a761@oracle.com>
Date: Tue, 9 Jul 2019 12:06:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <82879258-46a7-a6e9-ee54-fc3692c1cdc3@arm.com>
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313
 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090224
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313
 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090225
Cc: guohanjun@huawei.com, john.garry@huawei.com, rjw@rjwysocki.net,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 huawei.libin@huawei.com, jonathan.cameron@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 7/5/2019 3:12 AM, James Morse wrote:
> Hi guys,
>
> (CC: +kvmarm list)
>
> On 29/06/2019 03:42, Xiongfeng Wang wrote:
>> This patchset mark all the GICC node in MADT as possible CPUs even though it
>> is disabled. But only those enabled GICC node are marked as present CPUs.
>> So that kernel will initialize some CPU related data structure in advance before
>> the CPU is actually hot added into the system. This patchset also implement
>> 'acpi_(un)map_cpu()' and 'arch_(un)register_cpu()' for ARM64. These functions are
>> needed to enable CPU hotplug.
>>
>> To support CPU hotplug, we need to add all the possible GICC node in MADT
>> including those CPUs that are not present but may be hot added later. Those
>> CPUs are marked as disabled in GICC nodes.
> ... what do you need this for?
>
> (The term cpu-hotplug in the arm world almost never means hot-adding a new package/die to
> the platform, we usually mean taking CPUs online/offline for power management. e.g.
> cpuhp_offline_cpu_device())
>
> It looks like you're adding support for hot-adding a new package/die to the platform ...
> but only for virtualisation.
>
> I don't see why this is needed for virtualisation. The in-kernel irqchip needs to know
> these vcpu exist before you can enter the guest for the first time. You can't create them
> late. At best you're saving the host scheduling a vcpu that is offline. Is this really a
> problem?
>
> If we moved PSCI support to user-space, you could avoid creating host vcpu threads until
> the guest brings the vcpu online, which would solve that problem, and save the host
> resources for the thread too. (and its acpi/dt agnostic)
>
> I don't see the difference here between booting the guest with 'maxcpus=1', and bringing
> the vcpu online later. The only real difference seems to be moving the can-be-online
> policy into the hypervisor/VMM...

Isn't that an important distinction from a cloud service provider's 
perspective?

As far as I understand it, you also need CPU hotplug capabilities to 
support things like Kata runtime under Kubernetes. i.e. when 
implementing your containers in the form of light weight VMs for the 
additional security ... and the orchestration layer cannot determine 
ahead of time how much CPU/memory resources are going to be needed to 
run the pod(s).

Thanks,
-Maran

>
> I think physical package/die hotadd is a much bigger, uglier problem than doing the same
> under virtualisation. Its best to do this on real hardware first so we don't miss
> something. (cpu-topology, numa, memory, errata, timers?)
> I'm worried that doing virtualisation first means the firmware-requirements for physical
> hotadd stuff is "whatever Qemu does".
>
>
> Thanks,
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

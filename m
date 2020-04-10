Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F472C2BB86
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01EA720753
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dRu2yvzr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01EA720753
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B14F44B17D;
	Fri, 10 Apr 2020 07:19:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@oracle.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DdQSJtap3xVS; Fri, 10 Apr 2020 07:19:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB194B190;
	Fri, 10 Apr 2020 07:19:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 602D44B0B1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:20:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1RBA4UayX0yK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 06:20:13 -0400 (EDT)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2861B4B085
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:20:13 -0400 (EDT)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
 by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AAJ9uQ119046;
 Fri, 10 Apr 2020 10:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0G0SXSp0q/0L37C/DIXgGFdVawxsFUeBphgmgshcH20=;
 b=dRu2yvzr9ImMxm/HezfSd47lhuWROUTjEHynGyR9DBy7nO7bmMkoLmhuAJWwJON6FeTU
 hqE1oAJdHElx7hx7WYUGlG396cFo1Anke7DS6SKEWEpx5o1bDW6JLIJstAGKX/jM/AtZ
 KCyNOBtNt9falHzZOYrq78goxfzlGBrB7m9ZKJ+hk5fSZO1l6A2ZIsNxFzKWdwtLnh3j
 fCr2WRife1z/QU5/BTdn0qi9sqR2o0EtBdxbpIO2mVsyTA4vYcYUGk+tRk5qwLahwGEz
 N0kasfuYXdPzfIx6X9lisMIYlkdJoQwm6NAJylIMphHdujLrqzTeaelXFUcfMzAfu4SL qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
 by userp2120.oracle.com with ESMTP id 309gw4hr7u-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 10 Apr 2020 10:20:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
 by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AAHWhC105800;
 Fri, 10 Apr 2020 10:20:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
 by userp3030.oracle.com with ESMTP id 3091m714hy-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 10 Apr 2020 10:20:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
 by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03AAK7NV008352;
 Fri, 10 Apr 2020 10:20:07 GMT
Received: from [192.168.14.112] (/79.180.216.197)
 by default (Oracle Beehive Gateway v4.0)
 with ESMTP ; Fri, 10 Apr 2020 03:20:07 -0700
Subject: Re: Contribution to KVM.
To: Nadav Amit <nadav.amit@gmail.com>, Javier Romero <xavinux@gmail.com>
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
 <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
From: Liran Alon <liran.alon@oracle.com>
Message-ID: <9d46406f-c483-746b-058f-cceda22f1029@oracle.com>
Date: Fri, 10 Apr 2020 13:20:03 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586
 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586
 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100085
X-Mailman-Approved-At: Fri, 10 Apr 2020 07:19:01 -0400
Cc: like.xu@intel.com, kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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


On 10/04/2020 6:52, Nadav Amit wrote:
> 2. Try to run the tests with more than 4GB of memory. The last time I tried
>     (actually by running the test on bare metal), the INIT test that Liran
>     wrote failed.
>
Wasn't this test failure fixed with kvm-unit-test commit fc47ccc19612 
("x86: vmx: Verify pending LAPIC INIT event consume when exit on VMX_INIT")?
If not, can you provide the details of this new failure? As I thought 
this commit address the previous issue you have reported when running 
this test
on bare-metal.

Thanks,
-Liran

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

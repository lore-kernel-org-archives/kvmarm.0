Return-Path: <SRS0=o0cc=GZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1025C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 14:06:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 005B6239EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jan 2021 14:06:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 005B6239EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D2E4B1DC;
	Fri, 22 Jan 2021 09:06:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n2PEX1W9rBPc; Fri, 22 Jan 2021 09:06:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 396694B1EB;
	Fri, 22 Jan 2021 09:06:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D818C4B1DC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 09:06:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xDJfBcEFYRyb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jan 2021 09:06:18 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62C094B1DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jan 2021 09:06:16 -0500 (EST)
Received: from dggeme710-chm.china.huawei.com (unknown [172.30.72.57])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DMgxg5dpNz5KFb;
 Fri, 22 Jan 2021 22:04:55 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggeme710-chm.china.huawei.com (10.1.199.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 22 Jan 2021 22:06:03 +0800
Subject: Re: [RFC PATCH v4 0/2] Some optimization for stage-2 translation
To: Marc Zyngier <maz@kernel.org>
References: <20210122101358.379956-1-wangyanan55@huawei.com>
 <a6d4d16574fa76c4e519cdbff70cf950@kernel.org>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <4adad05d-5ac5-e9e1-62ec-b5c5c6c42081@huawei.com>
Date: Fri, 22 Jan 2021 22:06:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <a6d4d16574fa76c4e519cdbff70cf950@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme710-chm.china.huawei.com (10.1.199.106)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
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
Content-Type: multipart/mixed; boundary="===============8661503138971959168=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8661503138971959168==
Content-Type: multipart/alternative;
	boundary="------------798572566FE0CA565F08FFDD"
Content-Language: en-US

--------------798572566FE0CA565F08FFDD
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit

Hi Marc,

On 2021/1/22 19:47, Marc Zyngier wrote:
> Hi Yanan,
>
> On 2021-01-22 10:13, Yanan Wang wrote:
>> Hi, Will, Marc,
>> Is there any further comment on the v3 series I post previously?
>
> None, I was planning to queue them for 5.12 over the weekend.
>
>> If they are not fine to you, then I think maybe we should just turn
>> back to the original solution in v1, where I suggestted to filter out
>> the case of only updating access permissions in the map handler and
>> handle it right there.
>>
>> Here are the reasons for my current opinion:
>> With an errno returned from the map handler for this single case, there
>> will be one more vcpu exit from guest and we also have to consider the
>> spurious dirty pages. Besides, it seems that the EAGAIN errno has been
>> chosen specially for this case and can not be used elsewhere for other
>> reasons, as we will change this errno to zero at the end of the 
>> function.
>>
>> The v1 solution looks like more concise at last, so I refine the diff
>> and post the v4 with two patches here, just for a contrast.
>>
>> Which solution will you prefer now? Could you please let me know.
>
> I'm still very much opposed to mixing mapping and permission changes.
> How bad is the spurious return to a vcpu?
>
>
Actually, there is not much difference functionally for these two solutions.
I just thought there was a bit more change relatively in v3 for the new 
page-table framework.
But I still respect your opinion, so v3 is fine enough.  :)

Thanks,

Yanan.


--------------798572566FE0CA565F08FFDD
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hi Marc,<br>
    </p>
    <div class="moz-cite-prefix">On 2021/1/22 19:47, Marc Zyngier wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:a6d4d16574fa76c4e519cdbff70cf950@kernel.org">Hi Yanan,
      <br>
      <br>
      On 2021-01-22 10:13, Yanan Wang wrote:
      <br>
      <blockquote type="cite">Hi, Will, Marc,
        <br>
        Is there any further comment on the v3 series I post previously?
        <br>
      </blockquote>
      <br>
      None, I was planning to queue them for 5.12 over the weekend.
      <br>
      <br>
      <blockquote type="cite">If they are not fine to you, then I think
        maybe we should just turn
        <br>
        back to the original solution in v1, where I suggestted to
        filter out
        <br>
        the case of only updating access permissions in the map handler
        and
        <br>
        handle it right there.
        <br>
        <br>
        Here are the reasons for my current opinion:
        <br>
        With an errno returned from the map handler for this single
        case, there
        <br>
        will be one more vcpu exit from guest and we also have to
        consider the
        <br>
        spurious dirty pages. Besides, it seems that the EAGAIN errno
        has been
        <br>
        chosen specially for this case and can not be used elsewhere for
        other
        <br>
        reasons, as we will change this errno to zero at the end of the
        function.
        <br>
        <br>
        The v1 solution looks like more concise at last, so I refine the
        diff
        <br>
        and post the v4 with two patches here, just for a contrast.
        <br>
        <br>
        Which solution will you prefer now? Could you please let me
        know.
        <br>
      </blockquote>
      <br>
      I'm still very much opposed to mixing mapping and permission
      changes.
      <br>
      How bad is the spurious return to a vcpu?
      <br>
      <br>
      <br>
    </blockquote>
    Actually, there is not much difference functionally for these two
    solutions.<br>
    I just thought there was a bit more change relatively in v3 for <span style="color: rgb(32, 33, 36); font-family: arial, sans-serif; font-size: 28px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: pre-wrap; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(248, 249, 250); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"></span>
    the new page-table framework.<br>
    But I still respect your opinion, so v3 is fine enough.  :)<br>
    <p>Thanks,</p>
    <p>Yanan.<br>
    </p>
  </body>
</html>

--------------798572566FE0CA565F08FFDD--

--===============8661503138971959168==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8661503138971959168==--

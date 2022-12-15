Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDD5C00145
	for <kvmarm@archiver.kernel.org>; Thu, 15 Dec 2022 09:33:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25BDF4B93E;
	Thu, 15 Dec 2022 04:33:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FxMYmzYhLD20; Thu, 15 Dec 2022 04:33:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADE874B8D8;
	Thu, 15 Dec 2022 04:33:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15CE54B8D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2022 04:33:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LDRVqwwcoEGd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Dec 2022 04:33:32 -0500 (EST)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
 (mail-am0eur02on2086.outbound.protection.outlook.com [40.107.247.86])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C3EF4B88E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2022 04:33:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOCOhlPZ5fudmvJIEMTg4K/J6y8qHbc2Ur94DbvGlpY=;
 b=oTQHRXOlwtdJ2GVMLCI+vTTwJsP9BqU39F/M2wonqrttyz0ePBGtV/pxDv+JI4CaflbQD8paYNb+8lBe0DkP7p82pGxJOAUtWa02epbFJtdxAP2gOx/mt+8RIOS59tDAiIXsiF1rxSlsso4/bogjREPFlxdaQzA+afZYv93x3rM=
Received: from AS9P251CA0002.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:50f::10)
 by DB5PR08MB10287.eurprd08.prod.outlook.com (2603:10a6:10:4a5::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 09:33:29 +0000
Received: from AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:50f:cafe::eb) by AS9P251CA0002.outlook.office365.com
 (2603:10a6:20b:50f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12 via Frontend
 Transport; Thu, 15 Dec 2022 09:33:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT064.mail.protection.outlook.com (100.127.140.127) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.11 via Frontend Transport; Thu, 15 Dec 2022 09:33:28 +0000
Received: ("Tessian outbound 58faf9791229:v130");
 Thu, 15 Dec 2022 09:33:28 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 39bf6614655f3c73
X-CR-MTA-TID: 64aa7808
Received: from aaef675a5efc.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 3DEB4FFA-D153-49FA-A608-F94F09E553B2.1; 
 Thu, 15 Dec 2022 09:33:22 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id aaef675a5efc.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Thu, 15 Dec 2022 09:33:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baL46U/3VulJ04h/H0vOYgHynOl8C/thCPMBcB1F/DxO9TK+MNvEorQBznGdOKpFMhKe7YAsP3f1hq5BHsDigX5RZPkwQjfcqGP5qH1obyoZ3WudSwrq5Li/RWsCKSS13e6whmru1EXJBX5f1IyAwndPxXUwccRgxI7HfOGux2lxwk603S6PsIfMjobmOT69f2Ty7JgRrpSoooz8/cgcG35dqjMCGoB5skms3ffnWa3Fuit0UCL+RR/3vOk6GJf+qRlTZFooEhJZFMe92CLJkFTFHQGKfIYbuohCSiPqjk8Vo0/oq3jR1+mN587F5q7WevBd4hHFkQjY5U0jLUej4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOCOhlPZ5fudmvJIEMTg4K/J6y8qHbc2Ur94DbvGlpY=;
 b=mtoRtnw3fuviLBHBVtdazYnasJyiqHDBGtS28gq8TbC2L0/2/3I58wGxgwnhz6v32sS7d77Cxq18lUIX7/JMLIdgWk45GYq9UODzEmYEwponRuQNxSUpy1m00At0TI19wMdiKyyoJhLOJY7qCJBcJPsgvFFRXL4sBtP3B51CDhbMY1xL3KWWTwzQ2fFqEIF8mTldhVudM5wmM4jyyvf13YIA69fGZ23k6qXnes1efVALnPLpHFwKxYuwqeN32YtfHp+GKCkCjIdZPeYYt3x6bH9AlEy6Lib67Y3L6mq7cqWlA+qs/LEuXB6XgFZ/13HLE1N5PUXH3l4TxIXdN6veHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOCOhlPZ5fudmvJIEMTg4K/J6y8qHbc2Ur94DbvGlpY=;
 b=oTQHRXOlwtdJ2GVMLCI+vTTwJsP9BqU39F/M2wonqrttyz0ePBGtV/pxDv+JI4CaflbQD8paYNb+8lBe0DkP7p82pGxJOAUtWa02epbFJtdxAP2gOx/mt+8RIOS59tDAiIXsiF1rxSlsso4/bogjREPFlxdaQzA+afZYv93x3rM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by DB8PR08MB5404.eurprd08.prod.outlook.com (2603:10a6:10:117::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 09:33:20 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::e825:ff01:1f8:4c1f]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::e825:ff01:1f8:4c1f%5]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 09:33:20 +0000
Message-ID: <c19594a6-358b-c0de-b1f5-84de38015379@arm.com>
Date: Thu, 15 Dec 2022 09:33:17 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v1 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm s2
To: Oliver Upton <oliver.upton@linux.dev>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <Y5pvzKYdZK79nyZw@google.com>
Content-Language: en-US
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <Y5pvzKYdZK79nyZw@google.com>
X-ClientProxiedBy: LO2P265CA0469.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::25) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: AS8PR08MB6995:EE_|DB8PR08MB5404:EE_|AM7EUR03FT064:EE_|DB5PR08MB10287:EE_
X-MS-Office365-Filtering-Correlation-Id: d26a2fae-96c6-47ab-10b8-08dade7f6c68
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: /73afesSXSclbXBbFfzGQ5MvW8uPtM9TMlj+UmXCR1wdghPoWbXFJXN1hnPDpcGaMqRY0LxvDnQ+JnX6eNTTlCD2+LqtrWd9HhdB0u6wNyhnJbeIYDuveEQEDTEk7QwNTy3lHQTmFFwtWgd+et1/dO73e5P7VAshtDjHwZ+RII+p3DtEM/NqHLCf0xYZzA2dFtSWFzG+1gwYXfD6MkMhPiaFfRdyPQ99EeXBbzdGhUQS9ADhyUtdg6m52fw99Notb9wVUAw8Jc0pSz6OHQGJURN6nUlSFBL3i1azblZfoewXkjRPAhM8AU/agj3I5PjyhTOWrhio+lHahV11c3mG9Efy7Ou4+ovhPFnaCtaMn1IASt6QrmimGvVefPwy9YJlmzO8gi0ShjAAal8A0vF6+kdZwQmghQOfiF02fWNVv71I0wEC3aD8Q72jXoJzZOHzzebxaKXNw/Fvu32ZWpbIOIdSSZLmjUhJfqVaZAgYGnLLXGYV44OkkpuUNkZlkdfblanDaWnWXSCYObRIjOAVpSS03xmQsuxQ3ZHjF/NmSncfJkoXSS44yVQPKtocs9YCB+9DEgcksR2zPpgsIsq1jH40FZweKdzhSv2Vi4cbA1WmJBYcJEpcuKshzZOi0j00HC0pZwP2ckOvXwvBu6GV0Ak+6n1CXrS9h//pXB+/zPdXSDvng0JEYTeMXsFIS3zELy5a8PNv52PB0tdZxajBRppnFKagi17+KRkZZiGesf8=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AS8PR08MB6995.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(5660300002)(66476007)(2616005)(53546011)(26005)(8676002)(6512007)(6666004)(6506007)(31696002)(38100700002)(186003)(4326008)(41300700001)(86362001)(66946007)(8936002)(2906002)(478600001)(36756003)(44832011)(54906003)(6486002)(66556008)(6916009)(316002)(66899015)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5404
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 34592840-c1ef-4b9b-3c67-08dade7f674a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHwV1Bot7ZvufXz0kMfPY12WpSdp6HVFqP8uZnAKsF6XTVmGxco+POASPgGdLbODfqBWCxccUUsWlUzfO8nQB/Jv92U02oLUKd36DDlOActgutetWzzH366puq5mk1gLQdUcug76g0BE5Qp0uME91Ow/konfv0IA7ucEE8M7vF0qrfD/lJ4K0uY5rsthQ6Ug5pb9vb60B7lKYs5s5tNIW/OEQlLA6Ij20VUWzgeL5HuYuqpNkbKFigyW9hDuXMXQfv0DTBo9MdHZZabjqpDtfDAMnGDALy8enVVWw//MnRtJAAV+wka/y2jX4vF4JGpahQiCAhNcOpxiBr8yEfmex4t4UF8u3RCtzuz4b0zYCxaHy4ZkuKQkCSt0jZWA/lWbAyjJ25LI2OaOvBbcnOzgaGNw6h/hq0zG3v5EcZoLiDov9cGXmX4KBau8pX4Z7ifihjCvSQoKKIRuzc6zO7k/bxi0g2EDCREPx2Hm+ILYIX9t+XHh+/E2pYkLpJGoH+BLIJSohe01/WAmwub0H6lSKUs1KHxrzqW3iaboFsQN6WZIzkAOztD4qwJ6LHpz5OlaLdJVyeZv+tMd25+/admrpM53xNv02X7KxzfOy/EWI8UtFdMOj2kXlY76HSeFOqm9E6zKWai+EM4zh3PXIS07cDchw40JBIR8CppJo+if9fOHTvg3YZMWWKNoSDcBjIaoCfPC3t6eXQUreh3EWXbt97E5IhZlGtq52hUqOaez8CQ=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(46966006)(40470700004)(36840700001)(54906003)(36860700001)(2616005)(336012)(40460700003)(41300700001)(44832011)(2906002)(47076005)(8936002)(5660300002)(316002)(40480700001)(36756003)(6862004)(186003)(8676002)(4326008)(86362001)(70206006)(70586007)(31696002)(82310400005)(31686004)(66899015)(6666004)(356005)(26005)(6512007)(82740400003)(6506007)(53546011)(81166007)(478600001)(6486002)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 09:33:28.6693 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d26a2fae-96c6-47ab-10b8-08dade7f6c68
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10287
Cc: Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 15/12/2022 00:52, Oliver Upton wrote:
> On Tue, Dec 06, 2022 at 01:59:18PM +0000, Ryan Roberts wrote:
>> (appologies, I'm resending this series as I managed to send the cover letter to
>> all but the following patches only to myself on first attempt).
>>
>> This is my first upstream feature submission so please go easy ;-)
> 
> Welcome :)
> 
>> Support 52-bit Output Addresses: FEAT_LPA2 changes the format of the PTEs. The
>> HW advertises support for LPA2 independently for stage 1 and stage 2, and
>> therefore its possible to have it for one and not the other. I've assumed that
>> there is a valid case for this if stage 1 is not supported but stage 2 is, KVM
>> could still then use LPA2 at stage 2 to create a 52 bit IPA space (which could
>> then be consumed by a 64KB page guest kernel with the help of FEAT_LPA). Because
>> of this independence and the fact that the kvm pgtable library is used for both
>> stage 1 and stage 2 tables, this means the library now has to remember the
>> in-use format on a per-page-table basis. To do this, I had to rework some
>> functions to take a `struct kvm_pgtable *` parameter, and as a result, there is
>> a noisy patch to add this parameter.
> 
> Mismatch between the translation stages is an interesting problem...
> 
> Given that userspace is responsible for setting up the IPA space, I
> can't really think of a strong use case for 52 bit IPAs with a 48 bit
> VA. Sure, the VMM could construct a sparse IPA space or remap the same
> HVA at multiple IPAs to artificially saturate the address space, but
> neither seems terribly compelling.
> 
> Nonetheless, AFAICT we already allow this sort of mismatch on LPA &&
> !LVA systems. A 48 bit userspace could construct a 52 bit IPA space for
> its guest.

I guess a simpler approach would be to only use LPA2 if its supported by both
stage1 and stage2. Then the code could just use a static key in the few required
places. However, there is also a place where kvm_pgtable walks the user space s1
page table that is constructed by the kernel. For this to keep working, the
kernel would need to decide whether to use LPA2 based on the same criteria. But
it feels odd to have the kernel depend on LPA2 support at stage2. I'll wait for
your fuller review.

> 
> Marc, is there any real reason for this or is it just a byproduct of how
> LPA support was added to KVM?
> 
>> Support 52-bit Input Addresses: The main difficulty here is that at stage 1 for
>> 4KB pages, 52-bit IA requires a extra level of lookup, and that level is called
>> '-1'. (Although stage 2 can use concatenated pages at the first level, and
>> therefore still only uses 4 levels, the kvm pgtable library deals with both
>> stage 1 and stage 2 tables). So there is another noisy patch to convert all
>> level variables to signed.
>>
>> This is all tested on the FVP, using a test harness I put together, which does a
>> host + guest boot test for 180 configurations, built from all the (valid)
>> combinations of various FVP, host kernel and guest kernel parameters:
>>
>>  - hw_pa:		[48, lpa, lpa2]
>>  - hw_va:		[48, 52]
>>  - kvm_mode:		[vhe, nvhe, protected]
>>  - host_page_size:	[4KB, 16KB, 64KB]
>>  - host_pa:		[48, 52]
>>  - host_va:		[48, 52]
>>  - host_load_addr:	[low, high]
>>  - guest_page_size:	[64KB]
>>  - guest_pa:		[52]
>>  - guest_va:		[52]
>>  - guest_load_addr:	[low, high]
> 
> Wow, what a matrix!
> 
> In a later revision of this series it might be good to add support for
> LPA2 guests in KVM selftests. We currently constrain the IPA size to
> 48bits on !64K kernels.

Ahh - I did have a quick look at kselftests and kvm-unit-tests but it looked
like they were hard-coded for 48-bit IPA and it looked like quite an effort to
rework. I guess if it already supports 52 bit IPA for 64K kernels then I missed
something. I'll take another look and aim to get some tests implemented for a
future revision.
> 
> I'll have a deeper look at this series in the coming days.

Thanks!

> 
> --
> Thanks,
> Oliver

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

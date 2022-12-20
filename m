Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2941C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 09:01:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9224B3DA;
	Tue, 20 Dec 2022 04:01:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XJIfIJSno+OZ; Tue, 20 Dec 2022 04:01:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 662214B62E;
	Tue, 20 Dec 2022 04:01:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE94C4B62A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 04:01:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wpv42kzWO-Tv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Dec 2022 04:01:36 -0500 (EST)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CBFA4291D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 04:01:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erx/Ghq+9aXgjlqISqKVDfbk7awv/dz6FqUmcmeoisw=;
 b=vmvISCY6G2l/lS6FEfKOmBKeFrQl8wc37NnX6uIKQx8JM+IN/YrmgRpiUg5DDhhJGNoXkrp4YYuesv48VuZEQJiovLuSbOtDzdA/lf73CfuuBTsbUG4i/UzHfnV7/G1zlXzD62L8vVRMgrLNLj2G6YayC788W5ck/qQzR3Okj9E=
Received: from FR0P281CA0095.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a9::12)
 by DB8PR08MB5418.eurprd08.prod.outlook.com (2603:10a6:10:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.6; Tue, 20 Dec
 2022 09:01:31 +0000
Received: from VI1EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:d10:a9:cafe::2e) by FR0P281CA0095.outlook.office365.com
 (2603:10a6:d10:a9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.10 via Frontend
 Transport; Tue, 20 Dec 2022 09:01:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VI1EUR03FT041.mail.protection.outlook.com (100.127.145.15) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16 via Frontend Transport; Tue, 20 Dec 2022 09:01:30 +0000
Received: ("Tessian outbound 3ad958cd7492:v132");
 Tue, 20 Dec 2022 09:01:29 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1cd2692adfec9aba
X-CR-MTA-TID: 64aa7808
Received: from b19e76653062.1
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 88204C9D-70F8-4098-B967-343D521A065E.1; 
 Tue, 20 Dec 2022 09:01:22 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b19e76653062.1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Tue, 20 Dec 2022 09:01:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bio7Bvmg3yKDpAtRIOKJIVuUj6hOgNkuOtr6kr/qhvSrs2/9qd6N0I6Scds8xNfYRoSytEo+DuEzbpU032SwuO5Kowwdp41f39bm8b1BXoJ0mQdKpIU5X1ZKPUiCK2MVH4HiXjm5WJ3eJByVEcEJR3+2wQhI80TxGjWkry61Rk0Dpe0v/ZPrB55WJG04zuCrWLqc19cMj7NbS+vndD1SLUdp5o0bwT8mUfpOIzMHLm/x7KRSHNSuVy6gNPj+WdNJlVbhMntOJ10d2BS/q2FOgmD5DNNA2Kk+EQ83dKww/FhjXbpbZOk00XJKvSE1CHeYBCmiHAdvGTToKCdmmMnHtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=erx/Ghq+9aXgjlqISqKVDfbk7awv/dz6FqUmcmeoisw=;
 b=Yjor2YRlkQfrqxG8zSF1IaD9oCdeus7iEi/IY0u3y+fIxbpG++Vta5wPNQBM+fQilsqQ2WYjd8xpOteHjmVzHvfSkmTzDiddFONyb1zdKJAmQ+uWpNxpbCUCVaxPG7CCBd5mo5lGsZczwEtes1nf+0xMQ1ukjzoPG/nqfYu8tuvr3iUIittDQdYl00WD/qrTKLrvHtdybvqbmoncCMVQpyNZCF1/r7LaTZJrPtu7EBJEY4kZQ23jBeW+nbbgV3Uhla3DJJF2rozE1XEP5gw+PjsDk8VP7c5Jh45WSV5sGr927CMYDVOYz1/NW+/GwPjW3IiZVMrfammY/dkNdY855g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erx/Ghq+9aXgjlqISqKVDfbk7awv/dz6FqUmcmeoisw=;
 b=vmvISCY6G2l/lS6FEfKOmBKeFrQl8wc37NnX6uIKQx8JM+IN/YrmgRpiUg5DDhhJGNoXkrp4YYuesv48VuZEQJiovLuSbOtDzdA/lf73CfuuBTsbUG4i/UzHfnV7/G1zlXzD62L8vVRMgrLNLj2G6YayC788W5ck/qQzR3Okj9E=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com (2603:10a6:20b:34d::13)
 by AM8PR08MB5859.eurprd08.prod.outlook.com (2603:10a6:20b:1c6::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.6; Tue, 20 Dec
 2022 09:01:21 +0000
Received: from AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::e825:ff01:1f8:4c1f]) by AS8PR08MB6995.eurprd08.prod.outlook.com
 ([fe80::e825:ff01:1f8:4c1f%6]) with mapi id 15.20.5944.006; Tue, 20 Dec 2022
 09:01:21 +0000
Message-ID: <94981e1e-4e88-caa1-222a-7ba336bcd156@arm.com>
Date: Tue, 20 Dec 2022 09:01:19 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v1 10/12] KVM: arm64: Rework logic to en/decode
 VTCR_EL2.{SL0, SL2} fields
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <20221206135930.3277585-11-ryan.roberts@arm.com>
 <Y6D8mYpSY0K8EGO4@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <Y6D8mYpSY0K8EGO4@google.com>
X-ClientProxiedBy: LO4P123CA0320.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::19) To AS8PR08MB6995.eurprd08.prod.outlook.com
 (2603:10a6:20b:34d::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: AS8PR08MB6995:EE_|AM8PR08MB5859:EE_|VI1EUR03FT041:EE_|DB8PR08MB5418:EE_
X-MS-Office365-Filtering-Correlation-Id: 0593656c-f691-429e-019e-08dae268c914
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: rQj0rL6wj21kZNLjVQaml9Bw27rRICeeR2L4LgAo4l7AoEQztkF8V9TVM+10EJzRLCgg1M4pQbZyiAxT8CkJGYaNZsMZ49/+5CUNDlggqQvAOoc7UYkU3+JKl/21Cu0KYNmmKwwwgTbh0hZC5aUiNMjq/Qw0WthilBKftLTSHmT8jS7kii/BWfVjL7vyz122Yf6FPBZkFio9YGrJpz+wSE4WlieA4Ld70EzWqwjzdMwoclKIX8i07/uvgksaBbTc4wD9v6uAeccy5YV9+xEqhxfr0pRWYfODLx9pzOu1E23aXd0L2h+oyfkVt1gHFC3JZ1E7498oTaqlAbnZvzED0fQK1DNNZzw7qW2lfiXDCKzU/AAaC0re6v0lAivXWwEchs3H8D8pFtuv3777yc6/ZAqZw1LUjW9DvVjTF3x3UTkRfGLi6WSeBYKn8BH9cVAJajKTtOqafmzREmK20oqwpfZwBPtJNYEZUoZdQnxMd6/ktbYi1UcfZWEtH6U1gousGE/vnMypfCvKbEPbEhy84jcNTxYMopYKpOVBtNFfiNMxVP+VKNXkZikYYwV3SjjoFr3g0kaTF+PaQ10LHgAvZ3kyV8iUxbydnHyNdiuCYbWz0hKRbLdrveI3sPc5q6aIxMDUF07HNWwxyh8iCjZ1OmwO10iAhNoLum/5NtqAx01TQo7UvqMuEj6o2T3CWoAZpPR/77KaP9Do7CYFiNKRBkQNhwgtN3niIfUeggrXtHs=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:AS8PR08MB6995.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(38100700002)(2906002)(86362001)(6486002)(478600001)(31696002)(54906003)(6916009)(316002)(66946007)(41300700001)(66556008)(66476007)(2616005)(31686004)(83380400001)(36756003)(8676002)(4326008)(6512007)(53546011)(6506007)(8936002)(26005)(186003)(5660300002)(44832011)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5859
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VI1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0449982a-dd8b-48b4-0ccd-08dae268c37d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8B2HWPLqqJZD8BMPx/hDkSLocWxg7/ZSL++VKiZJphrVDWenpxyEJ4k6GXECm7dq0gx572cE9CcIaXIFJTBmBADzWXMwe2hdKg1S0y20GcFSSQrgwvSQW8Id+vrHZTV/fiMfI0sriqt8PCWpipCYgs31k4HYz+0DBFxPk8c6RVddJSWKTzgF/cS0DPnGupl7aTLqOQEBBPAatfyWkBsIUEvcnKtHKdiG5qQIDW5ggNHpBHdL5L+oSFrWH7B7m+HMgmnqerJB3BpgS2Owmvk5yzTgvj5pN8RL/Fw85PUSYr6rhnJiGGCKs1YkpzvkHQCD+UohpKaEiqW7wueHU8XzI7Fld87Ija2jjqY95uONS86jKyZFZAhSJKMFQ0K3WqnEDTtkeMWpLleaovoxuNwEac6Yp5sB3npzNpL6l1d5a3taGIb+o4U4e11Nhy3JW08Z305WExbHDGKpQO9IYgccV+4RKSKWfUj7ideMUrzKrfJjb58ajWoKe0wgsXu2Wqy1Qp3RhbWNhgMD/FSVgvJY2ciScPwa/6ARiLlWohD2WRhaq2U65O1ggoqBKAAjYZx3fMTk8Qio1jEyjFVsTK5Q3eYGbV2GUr2fcYf3I1steMPnVoGfllMyT4SfN2EfF934H7YIWNDvjP6Z04G3SAvov4G9qPa5Rfv9rFb5hrnfE9gFo/LUybJvhZAef96prChiyFOcMpeZws4IrybkynwBuvrTp+aIw1swv0Zh90nU7JM=
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(6862004)(316002)(44832011)(54906003)(31696002)(86362001)(83380400001)(47076005)(5660300002)(41300700001)(8936002)(31686004)(2906002)(82310400005)(336012)(478600001)(36860700001)(36756003)(53546011)(6506007)(6486002)(2616005)(81166007)(70586007)(8676002)(82740400003)(4326008)(40460700003)(70206006)(6512007)(26005)(186003)(40480700001)(356005)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 09:01:30.3260 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0593656c-f691-429e-019e-08dae268c914
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5418
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

On 20/12/2022 00:06, Oliver Upton wrote:
> Hi Ryan,
> 
> On Tue, Dec 06, 2022 at 01:59:28PM +0000, Ryan Roberts wrote:
>> In order to support 5 level translation, FEAT_LPA2 introduces the 1-bit
>> SL2 field within VTCR_EL2 to extend the existing 2-bit SL0 field. The
>> SL2[0]:SL0[1:0] encodings have no simple algorithmic relationship to the
>> start levels they represent (that I can find, at least), so replace the
>> existing macros with functions that do lookups to encode and decode the
>> values. These new functions no longer make hardcoded assumptions about
>> the maximum level and instead rely on KVM_PGTABLE_FIRST_LEVEL and
>> KVM_PGTABLE_LAST_LEVEL.
>>
>> This is preparatory work for enabling 52-bit IPA for 4KB and 16KB pages
>> with FEAT_LPA2.
>>
>> No functional change intended.
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> 
> Why do we need to support 5-level paging at stage-2?
> 
> A configuration of start_level = 0, T0SZ = 12 with 4K paging would
> result in 16 concatenated tables at level 0, avoiding the level -1
> lookup altogether.

Yes, agreed. And that's exactly what the code does. So we could remove this
patch from the series and everything would continue to function correctly. But I
was trying to make things more consistent and maintainable (this now works in
terms of KVM_PGTABLE_FIRST_LEVEL and KVM_PGTABLE_LAST_LEVEL for example).

That said, I haven't exactly been consistent in my refactoring; patch 11 just
adds a comment to kvm_vcpu_trap_get_fault_level() explaining that the new -1
level encodings will never be seen due to stage2 never using 5 levels of
translation.

So happy to remove this and replace with a comment describing the limitations if
that's your preference?

> 
> --
> Thanks,
> Oliver

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

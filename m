Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE000C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 14:28:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0727560F02
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 14:28:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0727560F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D384B0C9;
	Tue, 10 Aug 2021 10:28:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pqvN74Kzwh89; Tue, 10 Aug 2021 10:28:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5A294A1A7;
	Tue, 10 Aug 2021 10:28:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5748C4B0F9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:35:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lyDXoq92g5HZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:35:49 -0400 (EDT)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7FF44B0F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:35:49 -0400 (EDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wkxl7zXcwx6x5pGY4qMJYgTpjgNDanH0/g7CodZe+RMDMUq9RKCXmJlymkXtKG3iC4Fv+zytpGKQCvhPdkmVkjNT1YGhnBuSP7uzLRBJ4FqqIbvHNvyoRQmqF9SbtU6HoS6Jc//nXSL05PvjmibJRxea91WiPENtE8ak5x7dHjify/X+Ca8PdZ8lF3bAKAaFotdMamPOWq9Os1nhlMP+RWQb1I5Fk8qKHVsYqI8vqY83BVLXWl9vQpWtOrhIBz5Y5lXD0DDQlJXiPwWlItN9WdHkJQITib+cTd6lm4TURpXZAHxp7c9sPiY1u3e4i1SifHuWfb4la6SpW65Dpz4leA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mvp/x8s0Eq+oMJ1wW2gDN65tItXzRZ6IGgy6hBtvUDI=;
 b=k9mkyibx/R7lEgCcqkuThPXH1HlF3f7MyP4DET0LC1LSBe8tC+MH6OxCJU02O3vigx16Soct4Eh1frGzQgU4Ye07bfrw1TD3HM9+ixDDOQAdULnYH09XrTXK4VCG1cOvWSXnguqSnvRXAV3AeJUA6Hz0joGGvmjOYIY6H2G/PoBSeURUML1j37a3izi9zna60jcDetYzr4yRvYk3jDG2IIhtOnYpWbTmfEkbJxW1P7XnR9LojntK+l8hv+nb2pmUxKw4lL2g2Zstu8eHJ68Z1m8MBzsHPeRlASSrsTM1lJ4GrWyWKoSX4IGnwLF2nm3keld8v79pbeYauhuAOZ5T4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mvp/x8s0Eq+oMJ1wW2gDN65tItXzRZ6IGgy6hBtvUDI=;
 b=f4oqWCOaVUgqFdu0ZKrlI4mIV5kl1aNc3IExqD3kZFT68OWwdBPuV1A1giOfQwjlogEHOQQOZ7K08+uKp88oXlqaT6L9NOnwA1KFYcg9wNbSOlZmSK1qR5jw4WrPpqZaPFGsiF2l4DBL5t/crII3dSPPpzaNoNqCdFGFClJh0cMssC/rJQ4/ubixRSfcGsdxrRc5UITB9wHEoMby45ncW6ATTnQolqsdz/CFzoJC+tWmq0Po4Yn+9IVHxGW1xj5G9jQS5hqZPYnJuQAKzlC6np9u2bMlgBAclguDbKEInjPvuX9R1beNFDWZmjXG4qLYCVodDrbU7zZeAxT6vwlw9A==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3823.namprd12.prod.outlook.com (2603:10b6:208:168::26)
 by MN2PR12MB4080.namprd12.prod.outlook.com (2603:10b6:208:1d9::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 15:35:46 +0000
Received: from MN2PR12MB3823.namprd12.prod.outlook.com
 ([fe80::dcee:535c:30e:95f4]) by MN2PR12MB3823.namprd12.prod.outlook.com
 ([fe80::dcee:535c:30e:95f4%6]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 15:35:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [RFC PATCH 14/15] mm: introduce MIN_MAX_ORDER to replace
 MAX_ORDER as compile time constant.
Date: Mon, 09 Aug 2021 11:35:39 -0400
X-Mailer: MailMate (1.14r5820)
Message-ID: <D69C9107-F7ED-4E18-86D8-77877992F08F@nvidia.com>
In-Reply-To: <YQ+UbJtSWciIVqr4@kernel.org>
References: <20210805190253.2795604-1-zi.yan@sent.com>
 <20210805190253.2795604-15-zi.yan@sent.com> <YQ+UbJtSWciIVqr4@kernel.org>
X-ClientProxiedBy: BL1P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::21) To MN2PR12MB3823.namprd12.prod.outlook.com
 (2603:10b6:208:168::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.2.60.152] (216.228.112.21) by
 BL1P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.17 via Frontend Transport; Mon, 9 Aug 2021 15:35:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 615ac12c-7c4c-4ab2-8624-08d95b4b5b64
X-MS-TrafficTypeDiagnostic: MN2PR12MB4080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4080117513DC649CA321542CC2F69@MN2PR12MB4080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXrRjzkyQ4LcfLy4bJJwJyiZAnjM/RokXMpaUJW3Pk72QQhwTL4cUnCDtzjHafx9NBDWFKi0O22keLi48Tq+1JuiPxoz22V4y+XcZl3Gl6ri2/yjTlZj78SyBhT7PociyDisPoWQq2yVz5upUPIqmQwCuB9FFGNhgkt7sX9mxMlh62R5P5yFKJkFppwZBNKS6v/D96yMInRNh26SKb+z2lXaNq2vMGaZQNgY8Qn+7bVFohXvfPqMqo8vt9twSaVlYNu5tu0JYBxf6YR8IR/1/uVJYuUfVhdC41Vh3/BfMnnE88BNWTvdjZ3L12/E5NlI44z3pNXMr9AFfyYGO+6j4otDL76BjicG/3KMSvsBuNUJ+5ETIOMnbidFx1wHSIG5vJp9YbSgZLD3In/F8+otkk2irVyAB4ISUTfcw/ExToYhwqCG11RgX3/Z202k7V3En455p2bkA3Igl7Caz2yPK2SWA2EKTx1ng6IhXiZivMkY/wUQU4zqRLvTTEMZEYkVjZMniaT677Ie+ekoA+9/PzfR/vjuRUmjRU2d7fn3vTLTvBl+/9N1CSBNyCGbCBlsfW/7fDQgvQcFcEDT3z+m9dYxdfHZsPsYH+em7YoG8I9U4/7LcPIe3VEZN6AD3NyEjlW3R1Q6+dqzqZDGAFtlahhhXYMaYQEB/Z/c04MfKfiv5qaR8s3zNrGdBGNAueczW1sTVONitZjayLpC8Ccj/eVMnuGhL4lC9j4Zj52uIGU=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MN2PR12MB3823.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(66946007)(66476007)(21480400003)(5660300002)(2906002)(235185007)(186003)(66574015)(6486002)(26005)(6666004)(83380400001)(66556008)(36756003)(8676002)(33964004)(478600001)(8936002)(38100700002)(4326008)(956004)(2616005)(33656002)(7416002)(16576012)(316002)(86362001)(53546011)(54906003)(6916009)(45980500001)(72826004);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEd4dzQyemVOMmtuNHBmZDBlcjNzUTlTcWRoemc4MHl3Snp5VU5WdEV2RnZi?=
 =?utf-8?B?QlN3SmRxdlE4Y01YeDk3L0RJWUpYdUlHSVY0WE41RThHTTBsTEJDYUh0bGx3?=
 =?utf-8?B?YWl2U09mZ1F5azNHeUhuY3hhN1FFZXRvTFArUGdYQ0JDWDAwUzRpeDhId2J2?=
 =?utf-8?B?SGwwVTdCcmJBeENxeVN2ZG91Z0tiSURDRXdwRDg3MEdGa1BGb2NjT1ZMM2JV?=
 =?utf-8?B?Nk16Q0p5b3UwaVp0eU5IaVNnVXVVYzdkNDM0dDBnNFpvQVhSaERZSUc0NnNY?=
 =?utf-8?B?U0tRdXZJem5SWXYrM1VQaXM0TzFsNEtCTjd4Uml2YktvRVl4U2w5OEhNU1Ez?=
 =?utf-8?B?RnpFK2ErT0l5aUJkMmtEUGlQY1VDUEpVSjZJeCtmaHVLYnlRUVhXZFRjTVZo?=
 =?utf-8?B?a3hWNE5qMzdvWTdJUG9iVWEyTWJaK2lJaFVlSllNcFlUa0pGVmNKZTVMS3Fs?=
 =?utf-8?B?elI1MmFGNW4yaWgxeEtzWFhBd09pUEtiU2I1cU5MTG5xZ0Y0Yk9OamEvZ0RD?=
 =?utf-8?B?ZnZGMklrSk1CbWkzSGJSYXJISitzNEVhNnZTS2p0QzRiOVloZHYxenJXV2th?=
 =?utf-8?B?U05KQmNwbm1tRzZpS1c1cEVkamZqc2tLdnFkeGlhWlpwcm5UL294b1F2bGVN?=
 =?utf-8?B?M2piY2RleDFwMEwwVW5JaHpIU1RMdWxldERla1A0cEtERzNzNzdVMmJpSXBj?=
 =?utf-8?B?R2d1ZXVCZ1Bmb0RqZkVXK1ZmUE5TRDM4UXpBeFJkMnFobjlHSnl1UEIrWWZw?=
 =?utf-8?B?OHlyajdDSHdYUUFXMm9CeVhOT3dFb2ZXMDJVRVZYSnN6eExOZFNwNjh4eThU?=
 =?utf-8?B?UVNOU1d4RHFWTWQ4MUdjaHhsOU1ueUh6NEIraHFmaVhqQkZkMXlJUFhqcFMv?=
 =?utf-8?B?NCthaVM3YkRzTmk5dmc4d05GQlArb1UybXlRVEgzbkNLNkYrUWNnOWR4Tmg4?=
 =?utf-8?B?anByOEJOQ1cxd3ptRTBPTks2SmwwSzVaQ21NbmlaOTFOWnJLSU54NEFXZ0lZ?=
 =?utf-8?B?ejBmcWFLR3luRWtDaEkxaUtqckFJdmlHZlJSQzFZZG9PRW9Vc2I4RmZvcUd5?=
 =?utf-8?B?ODZ2VVJJWUxHb2tEVllxaTBMUVRxb2VwUU9KSUM2OUhLaHVXcWkwMHI0UUNt?=
 =?utf-8?B?UXZrNTVhSEdGblRiTFZQT0hKRG5TNDY2OWhrdU9aUzR2a3ZLcTcrZkNaKzgy?=
 =?utf-8?B?L0l1N0xobzN2aUE5Z3JxaDhWNENnb3k0YzRRUytBbTdqSmVFQTJ0N3laNTQv?=
 =?utf-8?B?WkpVODdaeXcwblFQTHhyNnhEUStDTW9DL3R5L1hoQ0RPMHZ6S0ZLejdRb2pS?=
 =?utf-8?B?OGVITW1SUEVtTU5VaVIydi85Q0IrZGY1bXVSMEpVNENNUFJrS1hYYTRQMFVo?=
 =?utf-8?B?Y0tsVS9QQTdZMGxEcFcxTUw3VnYyMlM5d2tkd0w0UXFlR1lzQnJ3V0xtQXhN?=
 =?utf-8?B?UG1GVURCWVczZWxpbkpyRitHbG9ZMEU3UVdpelZjMThMbnFaYWV6aDFxNUM2?=
 =?utf-8?B?b0kxZDJFb0lCMkplbk1KdWo1QkJLWXBOWHRvMFA3WGlHelpSQURwU2IrbzF0?=
 =?utf-8?B?Ui9raDhmNzUyK2NpdHR3bmxDbE1mNFYwWWtUNGh1M2xtMG13N0YrdkI0UXVj?=
 =?utf-8?B?SFhJWG50eG95aEwrMSs5NWtjRFppRms0a01QTkpyWmhMMStSeWd3eXVnNFZ0?=
 =?utf-8?B?MitTK3NCWm1lUDFiVFBoVGZKSXFaVzNpTjM3WGNpckY0K2RCNEdKczlOQlUw?=
 =?utf-8?Q?dlpYmh6REs58cPPWus9oUldMEmKPsW3VgixVOGB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615ac12c-7c4c-4ab2-8624-08d95b4b5b64
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 15:35:46.5903 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRJ53KmhIU4qN1z6998AIaihV+iwsM42Z8L157KIw/AgyKjDS3zKWndBH6AVDYLa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4080
X-Mailman-Approved-At: Tue, 10 Aug 2021 10:28:25 -0400
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@suse.cz>, Marc Zyngier <maz@kernel.org>,
 Christoph Lameter <cl@linux.com>, kvmarm@lists.cs.columbia.edu,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Mike Kravetz <mike.kravetz@oracle.com>
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
Content-Type: multipart/mixed; boundary="===============1920106160284520078=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============1920106160284520078==
Content-Type: multipart/signed;
 boundary="=_MailMate_C2137725-FB75-444B-91CC-971BC3B89A78_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"

--=_MailMate_C2137725-FB75-444B-91CC-971BC3B89A78_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8 Aug 2021, at 4:23, Mike Rapoport wrote:

> On Thu, Aug 05, 2021 at 03:02:52PM -0400, Zi Yan wrote:
>> From: Zi Yan <ziy@nvidia.com>
>>
>> For other MAX_ORDER uses (described below), there is no need or too mu=
ch
>> hassle to convert certain static array to dynamic ones. Add
>> MIN_MAX_ORDER to serve as compile time constant in place of MAX_ORDER.=

>>
>> ARM64 hypervisor maintains its own free page list and does not import
>> any core kernel symbols, so soon-to-be runtime variable MAX_ORDER is n=
ot
>> accessible in ARM64 hypervisor code. Also there is no need to allocati=
ng
>> very large pages.
>>
>> In SLAB/SLOB/SLUB, 2-D array kmalloc_caches uses MAX_ORDER in its seco=
nd
>> dimension. It is too much hassle to allocate memory for kmalloc_caches=

>> before any proper memory allocator is set up.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Quentin Perret <qperret@google.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  arch/arm64/kvm/hyp/include/nvhe/gfp.h | 2 +-
>>  arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 3 ++-
>>  include/linux/mmzone.h                | 3 +++
>>  include/linux/slab.h                  | 8 ++++----
>>  mm/slab.c                             | 2 +-
>>  mm/slub.c                             | 7 ++++---
>>  6 files changed, 15 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hy=
p/include/nvhe/gfp.h
>> index fb0f523d1492..c774b4a98336 100644
>> --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
>> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
>> @@ -16,7 +16,7 @@ struct hyp_pool {
>>  	 * API at EL2.
>>  	 */
>>  	hyp_spinlock_t lock;
>> -	struct list_head free_area[MAX_ORDER];
>> +	struct list_head free_area[MIN_MAX_ORDER];
>>  	phys_addr_t range_start;
>>  	phys_addr_t range_end;
>>  	unsigned short max_order;
>> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp=
/nvhe/page_alloc.c
>> index 41fc25bdfb34..a1cc1b648de0 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
>> @@ -226,7 +226,8 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, =
unsigned int nr_pages,
>>  	int i;
>>
>>  	hyp_spin_lock_init(&pool->lock);
>> -	pool->max_order =3D min(MAX_ORDER, get_order(nr_pages << PAGE_SHIFT)=
);
>> +
>> +	pool->max_order =3D min(MIN_MAX_ORDER, get_order(nr_pages << PAGE_SH=
IFT));
>>  	for (i =3D 0; i < pool->max_order; i++)
>>  		INIT_LIST_HEAD(&pool->free_area[i]);
>>  	pool->range_start =3D phys;
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 09aafc05aef4..379dada82d4b 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -27,11 +27,14 @@
>>  #ifndef CONFIG_ARCH_FORCE_MAX_ORDER
>>  #ifdef CONFIG_SET_MAX_ORDER
>>  #define MAX_ORDER CONFIG_SET_MAX_ORDER
>> +#define MIN_MAX_ORDER CONFIG_SET_MAX_ORDER
>>  #else
>>  #define MAX_ORDER 11
>> +#define MIN_MAX_ORDER MAX_ORDER
>>  #endif /* CONFIG_SET_MAX_ORDER */
>>  #else
>>  #define MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
>> +#define MIN_MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
>>  #endif /* CONFIG_ARCH_FORCE_MAX_ORDER */
>>  #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
>
> The end result of this #ifdef explosion looks entirely unreadable:

Just to clarify the use of #ifdef:

MAX_ORDER is changed to a boot time variable and it cannot be used
for static array declaration, so I added MIN_MAX_ORDER.

At the moment, there are three cases of setting MAX_ORDER and
MIN_MAX_ORDER:

1. CONFIG_ARCH_FORCE_MAX_ORDER tells the MAX_ORDER certain arch
needs at compilation time.
2. CONFIG_SET_MAX_ORDER allows to change MAX_ORDER when an arch
does not set its MAX_ORER and SPARSEMEM_VMEMMAP is set.
3. !SPARSEMEM_VMEMMAP and no CONFIG_ARCH_FORCE_MAX_ORDER, then
MAX_ORDER is set to 11 by default.

I agree the code is hard to read, I will clean this up.


>
> /* Free memory management - zoned buddy allocator.  */
> #ifndef CONFIG_ARCH_FORCE_MAX_ORDER
> #ifdef CONFIG_SET_MAX_ORDER
> /* Defined in mm/page_alloc.c */
> extern int buddy_alloc_max_order;
>
> #define MAX_ORDER buddy_alloc_max_order
> #define MIN_MAX_ORDER CONFIG_SET_MAX_ORDER
> #else
> #define MAX_ORDER 11
> #define MIN_MAX_ORDER MAX_ORDER
> #endif /* CONFIG_SET_MAX_ORDER */
> #else
>
> #ifdef CONFIG_SPARSEMEM_VMEMMAP
> /* Defined in mm/page_alloc.c */
> extern int buddy_alloc_max_order;
>
> #define MAX_ORDER buddy_alloc_max_order
> #else
> #define MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
> #endif /* CONFIG_SPARSEMEM_VMEMMAP */
> #define MIN_MAX_ORDER CONFIG_ARCH_FORCE_MAX_ORDER
> #endif /* CONFIG_ARCH_FORCE_MAX_ORDER */
>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 2c0d80cca6b8..d8747c158db6 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -244,8 +244,8 @@ static inline void __check_heap_object(const void =
*ptr, unsigned long n,
>>   * to do various tricks to work around compiler limitations in order =
to
>>   * ensure proper constant folding.
>>   */
>> -#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT - 1) <=3D 25 ? \
>> -				(MAX_ORDER + PAGE_SHIFT - 1) : 25)
>> +#define KMALLOC_SHIFT_HIGH	((MIN_MAX_ORDER + PAGE_SHIFT - 1) <=3D 25 =
? \
>> +				(MIN_MAX_ORDER + PAGE_SHIFT - 1) : 25)
>>  #define KMALLOC_SHIFT_MAX	KMALLOC_SHIFT_HIGH
>>  #ifndef KMALLOC_SHIFT_LOW
>>  #define KMALLOC_SHIFT_LOW	5
>> @@ -258,7 +258,7 @@ static inline void __check_heap_object(const void =
*ptr, unsigned long n,
>>   * (PAGE_SIZE*2).  Larger requests are passed to the page allocator.
>>   */
>>  #define KMALLOC_SHIFT_HIGH	(PAGE_SHIFT + 1)
>> -#define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT - 1)
>> +#define KMALLOC_SHIFT_MAX	(MIN_MAX_ORDER + PAGE_SHIFT - 1)
>>  #ifndef KMALLOC_SHIFT_LOW
>>  #define KMALLOC_SHIFT_LOW	3
>>  #endif
>> @@ -271,7 +271,7 @@ static inline void __check_heap_object(const void =
*ptr, unsigned long n,
>>   * be allocated from the same page.
>>   */
>>  #define KMALLOC_SHIFT_HIGH	PAGE_SHIFT
>> -#define KMALLOC_SHIFT_MAX	(MAX_ORDER + PAGE_SHIFT - 1)
>> +#define KMALLOC_SHIFT_MAX	(MIN_MAX_ORDER + PAGE_SHIFT - 1)
>>  #ifndef KMALLOC_SHIFT_LOW
>>  #define KMALLOC_SHIFT_LOW	3
>>  #endif
>> diff --git a/mm/slab.c b/mm/slab.c
>> index d0f725637663..0041de8ec0e9 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -466,7 +466,7 @@ static int __init slab_max_order_setup(char *str)
>>  {
>>  	get_option(&str, &slab_max_order);
>>  	slab_max_order =3D slab_max_order < 0 ? 0 :
>> -				min(slab_max_order, MAX_ORDER - 1);
>> +				min(slab_max_order, MIN_MAX_ORDER - 1);
>>  	slab_max_order_set =3D true;
>>
>>  	return 1;
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b6c5205252eb..228e4a77c678 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3564,8 +3564,9 @@ static inline int calculate_order(unsigned int s=
ize)
>>  	/*
>>  	 * Doh this slab cannot be placed using slub_max_order.
>>  	 */
>> -	order =3D slab_order(size, 1, MAX_ORDER, 1);
>> -	if (order < MAX_ORDER)
>> +
>> +	order =3D slab_order(size, 1, MIN_MAX_ORDER, 1);
>> +	if (order < MIN_MAX_ORDER)
>>  		return order;
>>  	return -ENOSYS;
>>  }
>> @@ -4079,7 +4080,7 @@ __setup("slub_min_order=3D", setup_slub_min_orde=
r);
>>  static int __init setup_slub_max_order(char *str)
>>  {
>>  	get_option(&str, (int *)&slub_max_order);
>> -	slub_max_order =3D min(slub_max_order, (unsigned int)MAX_ORDER - 1);=

>> +	slub_max_order =3D min(slub_max_order, (unsigned int)MIN_MAX_ORDER -=
 1);
>>
>>  	return 1;
>>  }
>> -- =

>> 2.30.2
>>
>
> -- =

> Sincerely yours,
> Mike.


=E2=80=94
Best Regards,
Yan, Zi

--=_MailMate_C2137725-FB75-444B-91CC-971BC3B89A78_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmERS0sPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKP2MQAKvlLqyN8YT/m8eUCmoSnNHzcukGKeh5MVde
/lNE1TGyGVyhqRb3SG1SbbTcp/BL56Hh54K178gNs1TrD5herman8TPZyRnYw3Rp
J0OZOej150aLip0edg1VOEJeeOzwP04S9nos1AjhRIjfUmL7J6mPms0xpe62tpu4
Yci6dpf6XpYVbpdfAr9lSZCF52QFWroIRmCIzvOok9EUpTylXBSlIiuZ6xBslp8U
cbRhMcml2g6Gi9M+qtdb0UxmJtoWzecadyYKXKnGb6PtODKXFeMrpCtCMu4/jl61
/Pz529Q3wgP00kWjEE57DQmgnY97qUy6JPIdQnVClsqK28b8Myq4qfDl3HWhMFIK
jB51Z0tx38BAKZi9TWVJfIDXiPQJTyT2hI8P2ryl/zZMwvH+wYwCzeffYhKW9CkU
7JnHADbwqtVKn8Su8k3sAYTW7Jvgj4E9I03byYLh4QsUWTVq4dz2MUs6HQRFapfe
YZpFBiu7S8zEMfy3mCRV8D7ctouEuc5AG/L5h+oyrZbHBBtFtas1JVqJsdvO5sn+
E+lN/7Ln8s06aVw8Up5aF0WaXV0/3l2B/Vmc0JZhZaB4hlGW1crp4tlzmmMePAVs
3CFc9oxAmqXeEIl14rRNHABGvfkwdSNyz0U6yDLCDj0PfxlUpz/sGql2oH1Agmcm
Upo59qtp
=4zJc
-----END PGP SIGNATURE-----

--=_MailMate_C2137725-FB75-444B-91CC-971BC3B89A78_=--

--===============1920106160284520078==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============1920106160284520078==--

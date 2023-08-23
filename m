Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2058.outbound.protection.outlook.com [40.107.105.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60A6C139
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yA3t3De8snSbwgiCy4I9UTnQdNrkpTYrlGD+C7nehtk=;
 b=EWpoWrFVgYc1W20TAAgf6yX/V4o7QJQ8dk+wbodOywc/V1q1VjtEYplUY0ZhTAsuT5aw6yHw+8id91tNllprXE8/kZoY0Wr4BfKUSN8FD0/oGx1CsUpwBBJWmoZWfw6k1Wox5zz1FzZllQ8uJTaKHBtoJpjGvIxcTbu0tIpwHOw=
Received: from DUZPR01CA0235.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::19) by DB9PR08MB8508.eurprd08.prod.outlook.com
 (2603:10a6:10:3d3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.25; Wed, 23 Aug
 2023 17:41:13 +0000
Received: from DBAEUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4b5:cafe::61) by DUZPR01CA0235.outlook.office365.com
 (2603:10a6:10:4b5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.25 via Frontend
 Transport; Wed, 23 Aug 2023 17:41:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT005.mail.protection.outlook.com (100.127.142.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6723.16 via Frontend Transport; Wed, 23 Aug 2023 17:41:12 +0000
Received: ("Tessian outbound 30c9f5e988c5:v175"); Wed, 23 Aug 2023 17:41:11 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6c5084cae1f356ef
X-CR-MTA-TID: 64aa7808
Received: from 9042a3dabb0a.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 153A7109-9910-4008-8006-0603192ADE91.1;
	Wed, 23 Aug 2023 17:41:01 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9042a3dabb0a.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 23 Aug 2023 17:41:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ct9QEMGZzIVOirIpjYBPmHNj/QqVXxVE+4pxXNh0TXaJlgT52Wk/JhC87awdbdySFEb6etETI/Fd5o+P0/f2jIWY9WG0g5GSb6plTAwagHvIMz9DOAutsJNfl63H06Biumw1Aj8Bgdvd4abFnmTQizUcf2ipn3UOPGM1HqBag84wg0ZYuo2Eb/NOEA96ZoF256EjAKcBCbIidlFcfVQ7WQsWT68AKyxRIYTCRSVT0Ni41znZ/kpHAPu1gJgX7smIjEe45D+PBlduAKTApjqTEQnzWzQfT+CSFelrhsBLz+U4zmokD63pfXElajcAGCPtnBw/MLlTnxTqwXr3tB7mKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yA3t3De8snSbwgiCy4I9UTnQdNrkpTYrlGD+C7nehtk=;
 b=e6VswFhWgNU3Q9y2KSfhZfkWpn9rNX+wX082lXdfOUp8O0zVntPbXZZm/n+Qft4LQpKv4zF1j7btyuNqzxyy8skw1u+lwxTzP0X19it/dwUwbwi3/yvx27LP4eNkESXKlG1xPs4NhxbOEBvCihzb9THFoiz8mPHYYGiB8myMT1cEB6C7ok08G7devZMWZjY9u5AvmMZcH6MCbKK5rAw8bPgvHgJvKhwZJvHS4fo3Tg9B4nuUHKM9Onh2iCt4VGB7Hz9xACcilViPhogEn/p68PQPeX5XRd5SO2xFbFEXJ05XsuWusSRsgo+YrgVOYtaRkdXgHLc5N6wPVrnfOUjjNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yA3t3De8snSbwgiCy4I9UTnQdNrkpTYrlGD+C7nehtk=;
 b=EWpoWrFVgYc1W20TAAgf6yX/V4o7QJQ8dk+wbodOywc/V1q1VjtEYplUY0ZhTAsuT5aw6yHw+8id91tNllprXE8/kZoY0Wr4BfKUSN8FD0/oGx1CsUpwBBJWmoZWfw6k1Wox5zz1FzZllQ8uJTaKHBtoJpjGvIxcTbu0tIpwHOw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com (2603:10a6:10:2cc::19)
 by AM9PR08MB6035.eurprd08.prod.outlook.com (2603:10a6:20b:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.26; Wed, 23 Aug
 2023 17:40:59 +0000
Received: from DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2]) by DB9PR08MB7179.eurprd08.prod.outlook.com
 ([fe80::adb0:61cb:8733:6db2%7]) with mapi id 15.20.6699.026; Wed, 23 Aug 2023
 17:40:59 +0000
Date: Wed, 23 Aug 2023 18:40:40 +0100
From: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v4 03/36] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <ZOZEmO6WGyVAcOqK@arm.com>
References: <20230807-arm64-gcs-v4-3-68cfa37f9069@kernel.org>
 <ZNOhjrYleGBR6Pbs@arm.com>
 <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>
 <ZN+qki9EaZ6f9XNi@arm.com>
 <aaea542c-929c-4c9b-8caa-ca67e0eb9c1e@sirena.org.uk>
 <ZOTnL1SDJWZjHPUW@arm.com>
 <43ec219d-bf20-47b8-a5f8-32bc3b64d487@sirena.org.uk>
 <ZOXa98SqwYPwxzNP@arm.com>
 <227e6552-353c-40a9-86c1-280587a40e3c@sirena.org.uk>
 <ZOY3lz+Zyhd5ZyQ9@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZOY3lz+Zyhd5ZyQ9@arm.com>
X-ClientProxiedBy: LO2P265CA0257.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::29) To DB9PR08MB7179.eurprd08.prod.outlook.com
 (2603:10a6:10:2cc::19)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DB9PR08MB7179:EE_|AM9PR08MB6035:EE_|DBAEUR03FT005:EE_|DB9PR08MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f73adc-daf8-48e7-b0e1-08dba4002463
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 +T1f/4FZoLnFlBrdlyHSDVzl5yNWpNBgXtAwvmxKcKmPi1kLpNrQJ5TxYggKNLwZoihqDTZgBczg2D/CXmyI1+XrhZkDjeOS0yug5bor+aOnNlcoY0h31C0ORmHcxQO0YUaB6ixWdd/xghadP90amhkL07j1dil3VsLA+1rfOe4Ev0Me+sX7OZCt1FH7NuC99Cbx/1XunFLm82aMQDNoDDcnjt5lknxUhmxT6kDG6Amrr64/VLW/WPuqpNFviS2Tm7DYFAhOl8K2ShySy+P6Gor8aSS6gj8WzfdSdQLTloG2h/S6GAVU6DWXOg3jQzwu3BgqUKMiooR8yMFuW2x1U3rb8tjohbaKD3E7H4NnzBPsrsZzM3DUiA0LidoD0U/n/QVWGk13/kIYAKSa0Okbf5DycvE3x4k5jT13Pwul11uFig8bL0K1fHz6YSP0jG+egwBCvcUoYL3AIqGy96Q8R+fAsM5V2fzN6RE2Pog9bnlQ4Jp3ZxQ5qIst8A2+x01WCp4fiYDuVYY0sc2Mb44ArbQyfrb2q0sKQsrACDeJ7taTFppig5oEmUP+iJ5sBCME
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB7179.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(346002)(366004)(136003)(186009)(451199024)(1800799009)(2616005)(6506007)(6486002)(316002)(8936002)(4326008)(8676002)(66556008)(54906003)(66476007)(66946007)(110136005)(6512007)(41300700001)(26005)(7416002)(5660300002)(6666004)(478600001)(83380400001)(66899024)(36756003)(86362001)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6035
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8e3c670b-9d32-45f1-3bec-08dba4001b35
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E36lyfh5d+h31HZDMqtdOBL03f2TyFw1TdKsbPvdAILr25Ej4dPaM3p6Bx5O8GDIg8ZoPxzR7AcMAVHjliLtHU53DMtcCpJEcPrIi/aHyX2/yDlRTfpJHbU9zDgjqseKe4NQU65GU/X0A/xdCh/xGALRG98JPTWN5U4py3G2Nc8NvEvXPpL0bosNwA+tHYgCopf8hL8a3uQBLPZR0HV4wjAmNQwpxTj2XJmvjPsgxwiBQ3cjaPoXXy/UfxvRnFSkbe2P/SPFg0Hgj7TmegD+uAjrrydzRT59IbbpMMJBPP753/6O5SjjBJ9SBOMdRK0xOijQyGVc7Br/EkmZ7r/zcR05cg9dXnY8LeuD2AUqIfHRT4VLIkO2DXLXcxPvavFpfzJ+uzCp69LTO1rG5VDp2N7OKlx/oAue4EvYyo/JXC37u2cGIyK5inhBpJaYjXEEgNUAfiytvk75iS94uBpFKGsbcb3p5CF/FsrdyNSqtN2X3U+Y6DqKR5UklUPjD0U2Lnar0X+689nSE5SzdGaNGTEYGJ0BNAY72vhGQCm7hQHCTS9ELvUS2rCiQurK6E6O31+QhTHQWtkL9g7jcBR1buUdMHq8p944vdeXd9vjb0NWLKwkhID0t++UCjTh+9u9hVeguh3ncJktvIsz2YA9Yt5oMMbyMf0wMeOkO5vZEa8Nb4fyEBRiY6DPppHPBAf81PXtuymafsjABK1Z3uZ4opQayjeu6LZEHRul6TRuc6FVuaZ+cqv9QKf8LK9aGRBKJYrmY1Crs5sEeG8C16VLiA==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199024)(82310400011)(186009)(1800799009)(40470700004)(36840700001)(46966006)(36756003)(478600001)(86362001)(316002)(6486002)(6506007)(70206006)(70586007)(110136005)(54906003)(6666004)(81166007)(41300700001)(6512007)(4326008)(8936002)(5660300002)(107886003)(82740400003)(26005)(8676002)(356005)(2616005)(83380400001)(336012)(40480700001)(40460700003)(66899024)(2906002)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2023 17:41:12.0369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f73adc-daf8-48e7-b0e1-08dba4002463
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8508

The 08/23/2023 17:45, Catalin Marinas wrote:
> On Wed, Aug 23, 2023 at 01:51:35PM +0100, Mark Brown wrote:
> > On Wed, Aug 23, 2023 at 11:09:59AM +0100, Szabolcs Nagy wrote:
> > > The 08/22/2023 18:53, Mark Brown wrote:
> > > > My sense is that they deployment story is going to be smoother with
> > > > defaults being provided since it avoids dealing with the issue of what
> > > > to do if userspace creates a thread without a GCS in a GCS enabled
> > > > process but like I say I'd be totally happy to extend clone3().  I will
> > > > put some patches together for that (probably once the x86 stuff lands).
> > > > Given the size of this series it might be better split out for
> > > > manageability if nothing else.
> > 
> > > i would make thread without gcs to implicitly disable gcs, since
> > > that's what's bw compat with clones outside of libc (the libc can
> > > guarantee gcs allocation when gcs is enabled).
> > 
> > That'd create a pretty substantial divergence with the x86 patches if
> > they land this time around, there's not enough time to rework them now -
> > I suppose it'd mainly bite people implementing libc type stuff but
> > still, doesn't feel great.
> 
> I don't mind the divergence in this area if the libc folks are ok with
> it. x86 can eventually use the clone3() interface if they want more
> flexibility, they'll just have to continue supporting the old one. I
> think we already diverge around the prctl().

i will have to prototype it, but in principle i'm ok with moving gcs
allocation to userspace and passing it as argument to clone3. i will
have to think if x86 divergence could cause issues.

to maximize compat with existing raw clone users gcs either has to
be disabled implicitly or allocated by the kernel. if we move gcs
management to userspace then disable sounds better to me.
(except vfork/fork does not have to disable etc.)

to support gcs, a libc would have to use clone3 or enable gcs in the
clone start code.

i don't know if we can allow disabled gcs thread creation with locked
gcs state. (i can see arguments both ways, so further prctl flag may
be needed which may be another divergence from x86)

i wonder if we can allow MAP_FIXED as well as MAP_FIXED_NOREPLACE
semantics for map_shadow_stack (MAP_FIXED makes sense if userspace
allocates thread stack + tls + gcs + guard pages with one PROT_NONE
mapping and then mprotects / map_shadow_stack on top of that) i.e.
if userspace manages the gcs it may need more flexibility here.
(for now i think separate gcs mapping works for me.)

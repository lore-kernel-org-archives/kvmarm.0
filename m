Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020090.outbound.protection.outlook.com [52.101.61.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD3621FF29
	for <kvmarm@lists.linux.dev>; Thu,  8 May 2025 21:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746738024; cv=fail; b=MPkQzpPua+ZGNjINQXbysnLACzgVPa1EkopAPaTWoNxAxf6gxxCfgtDdaSvYwbdE0jjVgoxD2NhMD7QelVQ+ts24G4FELtIkvfJQ1MPJ6btUWNTnOu5N/KpRM5vHTLku/c3vYT3ExFfSObjXEWt/HiYwZcqLZmfUVd4AoagcQN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746738024; c=relaxed/simple;
	bh=b371/CCRcHzpat13ng8u8Sz2HaxclKoR80IyXal4SGg=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kwQYFQwd3SrJyv8quVeDXC9Xt2yaEsiY3T5z5BI5/SVgu/ifsoeYA/BLPT4rvVbmsfLRYaREEwuiU743bE8QivsPyLveNQDGTR+NE32N1fcnNMkcaoWNB/dP9Iltttcq6RICIh06ko5vQ+xKsVrNAWUizBFtp7yt3G95R5+UzTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=PACCtZQm; arc=fail smtp.client-ip=52.101.61.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="PACCtZQm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5J632pj8ZH0R2I2Hp3FB5+PBk0nduYNquQPcnPXplor1Q6Qp1p445nnrTggHJrmydURKVy7g8i9eNZX6mXz1e5dtktnBY6LQhhrr4QfgOXrwKH88dSz01fFL37/INfc6bwmlhyyme1hNTlgnKX6QoSJ08WCT7XeeOKUy/9klH209mu1KGy2yKfwL3uZzF0oq22r2VbHSGoj2mMwroWNxYKFtHeOyc+WJYmtuzE420WJmFao8A8rTQ+AcO7oVgwdl4BNF43zgp1TEJYWJL8VYR3pGuXX+6OARJgR/gLQP3G0v5plBUJxXfXQXpDKzxirSZ/6O3rSno1fEgtDvbMMBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leEskXj5HT64qR6NlWTRZu7PgkH/7SraSecMLZSHzI4=;
 b=jh8h/j1/dvWv6tURxCjDlvU8LU5CgUpqVoFhubxbKGaKAF63uizENCxywHTqw30buHnhzsDPTCZYmdAs+CdZTo6vdTvZcjk2bmT/Wex+I0ucNA9qGxMLjdjOispnNo6hFtxKJD5wa4KSnof4sTzTRt3ek+GzqlhDe4njW6uPGqpyaRyXvQESI4xeTmxaM0A1Xg3TXXmNwTiwCFPV1+9wIE0IsWCdLhwYYQn6Ja61ZuU28lKiDgvQiMWrCYwCxTL7hvFAHVRCFisLpbNrSic24bUQkRmjaD1Gtz4Ss/I/tnbic5gWfOMUqWoiFO7++6lI+TNyu2ysBFdjrSZn/h97Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leEskXj5HT64qR6NlWTRZu7PgkH/7SraSecMLZSHzI4=;
 b=PACCtZQmVpHI/G8zBiKJm/xxRt4pshm8kYxEkJDSGlk8MgOptz5uIrr6v1vBeaxLt6ejxfw4/3flJ/WyhjElPS1ygEjpDhrWyZZ60zUM5RhMBsesko5A9k5vvo7tv9uOdHZ4ecOYjlhR5EGd1IJhfvLG4Y8OwFxJNLc4R3fInKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 SA1PR01MB8180.prod.exchangelabs.com (2603:10b6:806:339::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Thu, 8 May 2025 21:00:13 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8722.018; Thu, 8 May 2025
 21:00:13 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@linaro.org>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Rob Herring  (Arm)" <robh@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] arm64: errata: Work around AmpereOne's erratum AC04_CPU_23
Date: Thu,  8 May 2025 14:00:09 -0700
Message-ID: <20250508210009.428998-1-scott@os.amperecomputing.com>
X-Mailer: git-send-email 2.48.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:930:1c::12) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|SA1PR01MB8180:EE_
X-MS-Office365-Filtering-Correlation-Id: 59cdbbb2-fde0-4938-223d-08dd8e735366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|52116014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nH+qm3Ep5Y70ZXKFTKV+BmjdVtAkRMY+v/BoqEsCvGo1Rntt3Y49BjF2pybp?=
 =?us-ascii?Q?W5eskONSf9Ze1k+WW/XH4Y/q+X8kvNviazbQ9qINiEG6rq8X3eyaZUx/JIC4?=
 =?us-ascii?Q?RTDO0eMvL1WE0E9tZNxFO4fdzHVLr2YsgpzhCIgvJS3jjH+BOzgbNLMnv+fL?=
 =?us-ascii?Q?rl2/wJZ7KFw6czBqt/j0YJuGxihQaKKM370SNRBfgvEYiQIUr3EkeGE1OkIZ?=
 =?us-ascii?Q?rrCy1QT//uc5N6FFfUCpjvjgIML7SDZBBg83HAdL/Nig56EFfw6cw6KsyEa9?=
 =?us-ascii?Q?XrfnHNry+tXLel9hllkxsODo+y3cOcj9U9w+aXZEor7lrHjqMyXkLhvKGV/d?=
 =?us-ascii?Q?Sw0cndMkKLIQmg9npjwHRT+3B2YAHJZEg6ywM1RrrYniddrXTqJyClCxiw9A?=
 =?us-ascii?Q?Zp+gnr/jXq24me1VIgEf25OnwrVZebFjG/yWLVD/bOeYHmEo4pAeq9lKMNum?=
 =?us-ascii?Q?/dJWllg2gsMerrf/p7HqmwPENlxVKscARlBqt/FFhvxCimBsNuRCgvyGbTAH?=
 =?us-ascii?Q?CT9R87tIXObPP7RNeWucAxGN/9/omyZAjdaXhCMBvbeWPU97l+0uq4PCxa5b?=
 =?us-ascii?Q?oCvJpuUCcZRM7XTT80Y0TUA+bz70AQidb4f3AJ7lreifJsBdt08tX1Vwu1Gn?=
 =?us-ascii?Q?M00fvUuSpApqSufMs7zuNrgf8UBxK1dLGjDnoXFifroMdpqzbjmhTkhgHm6k?=
 =?us-ascii?Q?GJWaIazyRD4n9nOPoTW/B/oKa+bHOolwRNzMaShXKDeTkdlRtxErjgTf1MJG?=
 =?us-ascii?Q?80tCx6870pLHizGpb5SucjCMtGYsRvMYv/YjdHaHXlyCHhVKxS0c1VXRa4Ag?=
 =?us-ascii?Q?JhG1jOaumZSbM5YaFehi9401ANSHfUZzyNWXEwJ+yrdM64PSIUChs3/fhSxC?=
 =?us-ascii?Q?UJ+Sr2CMSEll5d2ek1MFuq9028ATHAssvGxCR6FNdtQUZCOmkjy74eHG9+4S?=
 =?us-ascii?Q?SyC97IZf6FWPpxNn5pchepJEkw9hDINGF3mJEg9FGYlKAQQiQZWAff+95ns4?=
 =?us-ascii?Q?Pu1+SENCTgimxYVddkvvrnvbKVs+yrwzmFdN1mlq9Ivfx/z5VWdfs9qZyBeS?=
 =?us-ascii?Q?WoHgCf4ZdpOa4Yh1cUx/yQuhBHNd/yQuilJpWkYg6TCZC8iOiEyeG5+HPNK/?=
 =?us-ascii?Q?ej27E0kzk68bsMOZXCDqI5YgeyIwXyglFeFAm7Lco3qMuMcn1MclkYIumfOv?=
 =?us-ascii?Q?5yfaiSQyadaDZvN1pg0bfpEeGqEr6520fJxZuuLGb3DfTZbq8laTa2p6/4Wf?=
 =?us-ascii?Q?IyjBJX0dHg5xG2CoLbqw6AHVmgyqhBUQL8iEW6r+i6I4g/L6vHZ7JlxHtM7v?=
 =?us-ascii?Q?uOXv1UqDe8vPnwTDu8TfphlfK7EN+wY30GnsTuGbTZmYjZNJzG58/jMqZo03?=
 =?us-ascii?Q?bzQGy/spaS+V+qopBrG7hpiRbuMtmmlA3ueH9B8wpU7T4uqNMos4KEtdsrMA?=
 =?us-ascii?Q?iInM3LkLsbFIPG2Lcmk+csEzmAtifqqqDmObGme47qyuPMXhnrAqcWzLauQA?=
 =?us-ascii?Q?fjWo98g7bmVcnuY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(52116014)(366016)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eYtgG91/98wrYA3fXJC9YvVVPoR/amzv1BBE4c58idxTeSkHzHitvYact0Pe?=
 =?us-ascii?Q?oFWcBAsRdazjVXgAwDvxuf7s97FgxnSuotPR8ZwS0I2JdY1F5JP/GDHxjerC?=
 =?us-ascii?Q?uIY0IVJcSIDj0k2SnxKqGmrJ0ZfvdkWYMYeM+Fn1AQIQ6UklBx+CeDgWnC90?=
 =?us-ascii?Q?iYHjidYjvmKh7w/7snwhYKfTxE1s2ABVc2OuunUbmpdN2cCmcFDPEbf9glNk?=
 =?us-ascii?Q?VhwnuIfIAa77M4ZBI83NWLNmfm++WL6oSMvGMhtSSX2H35IVK1NQ+4D4Cqyo?=
 =?us-ascii?Q?wNrdo67brVBKx+hacfPBeYGHRH8WHfsYoD7kqthMi0vVsMYCK4q32rEhCG7u?=
 =?us-ascii?Q?XCgIknjcCUkBHzoyRx0kd8ezjR0dZ+pJAF1/DjciY1xcLxD0bkxeBsxGxVqg?=
 =?us-ascii?Q?sJgFhE3jhlMUiray5KUkTurME899S1JTGatJkiWBTWSWdiI1bF3qpm1hwZMA?=
 =?us-ascii?Q?rWYf4ssF6FQE2MDlSIkeHq/7yEgbCoHsAXhTGtgj1iU53DtQkPlh0L57ZUk5?=
 =?us-ascii?Q?qRqUevjEba0EmxTIkwoQvSg98mhDaobSahlxHyf86TDnLIkpszlw7wC4z/S/?=
 =?us-ascii?Q?sGHbACoFoGq5acUfnJmqsyB/VET03JmHG0MkFeYAuCHqPte6NJ0mwfUJKmPO?=
 =?us-ascii?Q?V18IJlLFChGyyyEuxcvx2wvQQpTF5L3bmeu4t6JFyGz7aP4O6IqcUJb2xfNr?=
 =?us-ascii?Q?I7rjGViIAjCZB2px02wMIHufWmgDyPZKhBYD5w/z1jkPMkiMRH+0+P2pQI01?=
 =?us-ascii?Q?6/hJfARapplqRURFPuKStJZzudeabqXx5NMtsI5njnEtvWojs2c2IClPYZHO?=
 =?us-ascii?Q?07Em3b2p3ZIgIlUr6t3Ktd7iAEgcEGUMiVXSsgCrpRSMkoHOlKEM6FZ+Bu6P?=
 =?us-ascii?Q?f5w88s4DC5MuK5YGlyQW21t0yM6FEZvOzwZckV/wtVff9kwJ6wI3kVjvfUvG?=
 =?us-ascii?Q?T9x+FfnShAaDyXXoPhuKPU8VxRpblrpjfrnd0Lvky7Sn18kZ6pFrcgzggNWL?=
 =?us-ascii?Q?T/2xRIBg7yin400tWPOl/dHkKUs0I2YshO7vs6rj7VJrnrg3L1/Te+Os3s3s?=
 =?us-ascii?Q?aO4+yMR2MQS8NjVzgzl/F8y8c8D8pqsKyCFF3QfDJY0kWDtSfTWVxKGI35S6?=
 =?us-ascii?Q?8QIwP7Wh7ep572yXEc+fVWZEZJ/WmeGIqtTuxJxu7L4RTxCKvUmMDwaFGA/U?=
 =?us-ascii?Q?p7w8YunPx8B08PxIbyn3HeGWvgClnY4Wd1cne8Fd9O87atoRNw/dtZjGb2g8?=
 =?us-ascii?Q?flIj51MIODMj30WdbcCtQfDPDU4vXZgoqiCsMJHhRv0CNwmSrLWrtfQaSNzx?=
 =?us-ascii?Q?CEZlw1qrVAtUc0lDaJ5fRj02QovgGQYm2AJE6ejuCJrfvWXLcJ6cFCMKbmME?=
 =?us-ascii?Q?XYea70/6fz0U/K3QnM/3Iac92XfnpaRoOfEqWlIU+qfkZMrfwQK6waCz0aVS?=
 =?us-ascii?Q?xu/kFExZlvABXlVOSYVMYcamSRKaUC2KMZsHkHDrJdtJIHz0kjX6AGEDKpSC?=
 =?us-ascii?Q?Qm/rETOMQpl3omJ8Njgs7itcHqvkMOHHGFHB6RnkMQXnSwOWyxP26lqou8uq?=
 =?us-ascii?Q?4pn2LN0uufpmDbKZd3icT2kS6BWp96Lr7ENtA0FAESymzIX7y36AmOK71DGw?=
 =?us-ascii?Q?poTbeBqxFGdAxzQRg31TUsM=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cdbbb2-fde0-4938-223d-08dd8e735366
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 21:00:13.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpqT+CrqI39qJpybmPa9w5a+dDBe8bz43w7dwoL9xv6NfRAjeZ+vduIIw8nSW0E2RBBMmhVkhK+3soO9BXHiYm+xxND/JjknxuAp3iKXsnQnRQaUxqgvuRBdlzWC/BUy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8180

On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
translations for data addresses initiated by load/store instructions.
Only instruction initiated translations are vulnerable, not translations
from prefetches for example. A DSB before the store to HCR_EL2 is
sufficient to prevent older instructions from hitting the window for
corruption, and an ISB after is sufficient to prevent younger
instructions from hitting the window for corruption.

Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
---
v2: https://lore.kernel.org/kvmarm/20250425024741.1309893-1-scott@os.amperecomputing.com/
Changes since v2:
 - Apply the workaround before alternatives are applied (Marc)
 - Also catch stores to HCR_EL2 in assembly files (Marc)
 - Added a sysreg_clear_set_hcr() helper for the HCR_EL2 fiddling in
   vgic-v3-sr.c that I had previously missed.

v1: https://lore.kernel.org/kvmarm/20250415154711.1698544-2-scott@os.amperecomputing.com/
Changes since v1:
 - Add a write_sysreg_hcr() helper (Oliver)
 - Add more specific wording in the errata description (Oliver & Marc)

 arch/arm64/Kconfig                      | 17 ++++++++++++++++
 arch/arm64/include/asm/el2_setup.h      |  2 +-
 arch/arm64/include/asm/hardirq.h        |  4 ++--
 arch/arm64/include/asm/sysreg.h         | 27 +++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c          | 14 +++++++++++++
 arch/arm64/kernel/hyp-stub.S            |  2 +-
 arch/arm64/kvm/at.c                     |  8 ++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  4 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c         |  4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c            |  4 ++--
 arch/arm64/tools/cpucaps                |  1 +
 16 files changed, 78 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a182295e6f08b..3ae4e80e3002b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -464,6 +464,23 @@ config AMPERE_ERRATUM_AC03_CPU_38
 
 	  If unsure, say Y.
 
+config AMPERE_ERRATUM_AC04_CPU_23
+        bool "AmpereOne: AC04_CPU_23:  Failure to synchronize writes to HCR_EL2 may corrupt address translations."
+	default y
+	help
+	  This option adds an alternative code sequence to work around Ampere
+	  errata AC04_CPU_23 on AmpereOne.
+
+	  Updates to HCR_EL2 can rarely corrupt simultaneous translations for
+	  data addresses initiated by load/store instructions. Only
+	  instruction initiated translations are vulnerable, not translations
+	  from prefetches for example. A DSB before the store to HCR_EL2 is
+	  sufficient to prevent older instructions from hitting the window
+	  for corruption, and an ISB after is sufficient to prevent younger
+	  instructions from hitting the window for corruption.
+
+	  If unsure, say Y.
+
 config ARM64_WORKAROUND_CLEAN_CACHE
 	bool
 
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index ebceaae3c749b..2500fd0a1f66a 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -38,7 +38,7 @@
 
 	orr	x0, x0, #HCR_E2H
 .LnVHE_\@:
-	msr	hcr_el2, x0
+	msr_hcr_el2 x0
 	isb
 .endm
 
diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index cbfa7b6f2e098..77d6b8c63d4e6 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -41,7 +41,7 @@ do {									\
 									\
 	___hcr = read_sysreg(hcr_el2);					\
 	if (!(___hcr & HCR_TGE)) {					\
-		write_sysreg(___hcr | HCR_TGE, hcr_el2);		\
+		write_sysreg_hcr(___hcr | HCR_TGE);			\
 		isb();							\
 	}								\
 	/*								\
@@ -82,7 +82,7 @@ do {									\
 	 */								\
 	barrier();							\
 	if (!___ctx->cnt && !(___hcr & HCR_TGE))			\
-		write_sysreg(___hcr, hcr_el2);				\
+		write_sysreg_hcr(___hcr);				\
 } while (0)
 
 static inline void ack_bad_irq(unsigned int irq)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2639d3633073d..7284828f0dc9e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1091,6 +1091,15 @@
 	__emit_inst(0xd5000000|(\sreg)|(.L__gpr_num_\rt))
 	.endm
 
+	.macro	msr_hcr_el2, reg
+#if IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23)
+	dsb	nsh
+	msr	hcr_el2, \reg
+	isb
+#else
+	msr	hcr_el2, \reg
+#endif
+	.endm
 #else
 
 #include <linux/bitfield.h>
@@ -1178,6 +1187,13 @@
 		write_sysreg(__scs_new, sysreg);			\
 } while (0)
 
+#define sysreg_clear_set_hcr(clear, set) do {				\
+	u64 __scs_val = read_sysreg(hcr_el2);				\
+	u64 __scs_new = (__scs_val & ~(u64)(clear)) | (set);		\
+	if (__scs_new != __scs_val)					\
+		write_sysreg_hcr(__scs_new);			\
+} while (0)
+
 #define sysreg_clear_set_s(sysreg, clear, set) do {			\
 	u64 __scs_val = read_sysreg_s(sysreg);				\
 	u64 __scs_new = (__scs_val & ~(u64)(clear)) | (set);		\
@@ -1185,6 +1201,17 @@
 		write_sysreg_s(__scs_new, sysreg);			\
 } while (0)
 
+#define write_sysreg_hcr(__val) do {					\
+	if (IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23) &&		\
+	   (!system_capabilities_finalized() ||				\
+	    alternative_has_cap_unlikely(ARM64_WORKAROUND_AMPERE_AC04_CPU_23))) \
+		asm volatile("dsb nsh; msr hcr_el2, %x0; isb"		\
+			     : : "rZ" (__val));				\
+	else								\
+		asm volatile("msr hcr_el2, %x0"				\
+			     : : "rZ" (__val));				\
+} while (0)
+
 #define read_sysreg_par() ({						\
 	u64 par;							\
 	asm(ALTERNATIVE("nop", "dmb sy", ARM64_WORKAROUND_1508412));	\
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 6b0ad5070d3e0..59d723c9ab8f5 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -557,6 +557,13 @@ static const struct midr_range erratum_ac03_cpu_38_list[] = {
 };
 #endif
 
+#ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
+static const struct midr_range erratum_ac04_cpu_23_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -875,6 +882,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
 		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
 	},
+#endif
+#ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
+	{
+		.desc = "AmpereOne erratum AC04_CPU_23",
+		.capability = ARM64_WORKAROUND_AMPERE_AC04_CPU_23,
+		ERRATA_MIDR_RANGE_LIST(erratum_ac04_cpu_23_list),
+	},
 #endif
 	{
 		.desc = "Broken CNTVOFF_EL2",
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index ae990da1eae5a..36e2d26b54f5c 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -97,7 +97,7 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 2:
 	// Engage the VHE magic!
 	mov_q	x0, HCR_HOST_VHE_FLAGS
-	msr	hcr_el2, x0
+	msr_hcr_el2 x0
 	isb
 
 	// Use the EL1 allocated stack, per-cpu offset
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f74a66ce3064b..9c13e70fadf5e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -516,7 +516,7 @@ static void __mmu_config_save(struct mmu_config *config)
 
 static void __mmu_config_restore(struct mmu_config *config)
 {
-	write_sysreg(config->hcr,	hcr_el2);
+	write_sysreg_hcr(config->hcr);
 
 	/*
 	 * ARM errata 1165522 and 1530923 require TGE to be 1 before
@@ -1267,7 +1267,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 skip_mmu_switch:
 	/* Clear TGE, enable S2 translation, we're rolling */
-	write_sysreg((config.hcr & ~HCR_TGE) | HCR_VM,	hcr_el2);
+	write_sysreg_hcr((config.hcr & ~HCR_TGE) | HCR_VM);
 	isb();
 
 	switch (op) {
@@ -1350,7 +1350,7 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			val |= HCR_NV | HCR_NV1;
 
-		write_sysreg(val, hcr_el2);
+		write_sysreg_hcr(val);
 		isb();
 
 		par = SYS_PAR_EL1_F;
@@ -1375,7 +1375,7 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		if (!fail)
 			par = read_sysreg_par();
 
-		write_sysreg(hcr, hcr_el2);
+		write_sysreg_hcr(hcr);
 		isb();
 	}
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index b741ea6aefa58..06aa37dbc957d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -301,7 +301,7 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
 
-	write_sysreg(hcr, hcr_el2);
+	write_sysreg_hcr(hcr);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 58f0cb2298cc2..eef15b374abb0 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -124,7 +124,7 @@ SYM_FUNC_START(__hyp_do_panic)
 	/* Ensure host stage-2 is disabled */
 	mrs	x0, hcr_el2
 	bic	x0, x0, #HCR_VM
-	msr	hcr_el2, x0
+	msr_hcr_el2 x0
 	isb
 	tlbi	vmalls12e1
 	dsb	nsh
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index f8af11189572f..aada42522e7be 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -100,7 +100,7 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
 	msr	mair_el2, x1
 
 	ldr	x1, [x0, #NVHE_INIT_HCR_EL2]
-	msr	hcr_el2, x1
+	msr_hcr_el2 x1
 
 	mov	x2, #HCR_E2H
 	and	x2, x1, x2
@@ -262,7 +262,7 @@ reset:
 
 alternative_if ARM64_KVM_PROTECTED_MODE
 	mov_q	x5, HCR_HOST_NVHE_FLAGS
-	msr	hcr_el2, x5
+	msr_hcr_el2 x5
 alternative_else_nop_endif
 
 	/* Install stub vectors */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 31173c6946951..d1488d4e51413 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -309,7 +309,7 @@ int __pkvm_prot_finalize(void)
 	 */
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 
-	write_sysreg(params->hcr_el2, hcr_el2);
+	write_sysreg_hcr(params->hcr_el2);
 	__load_stage2(&host_mmu.arch.mmu, &host_mmu.arch);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7d2ba6ef02618..4024fafbe3594 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -142,7 +142,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	__deactivate_traps_common(vcpu);
 
-	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
+	write_sysreg_hcr(this_cpu_ptr(&kvm_init_params)->hcr_el2);
 
 	__deactivate_cptr_traps(vcpu);
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 50aa8dbcae75b..f8a91780e49a9 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -446,7 +446,7 @@ u64 __vgic_v3_get_gic_config(void)
 	if (has_vhe()) {
 		flags = local_daif_save();
 	} else {
-		sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
+		sysreg_clear_set_hcr(0, HCR_AMO | HCR_FMO | HCR_IMO);
 		isb();
 	}
 
@@ -461,7 +461,7 @@ u64 __vgic_v3_get_gic_config(void)
 	if (has_vhe()) {
 		local_daif_restore(flags);
 	} else {
-		sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
+		sysreg_clear_set_hcr(HCR_AMO | HCR_FMO | HCR_IMO, 0);
 		isb();
 	}
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 731a0378ed132..faacdfb328af6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -184,7 +184,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	___deactivate_traps(vcpu);
 
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 
 	if (has_cntpoff()) {
 		struct timer_map map;
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 3d50a1bd2bdbc..ec25698186297 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -63,7 +63,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 	__load_stage2(mmu, mmu->arch);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
-	write_sysreg(val, hcr_el2);
+	write_sysreg_hcr(val);
 	isb();
 }
 
@@ -73,7 +73,7 @@ static void exit_vmid_context(struct tlb_inv_context *cxt)
 	 * We're done with the TLB operation, let's restore the host's
 	 * view of HCR_EL2.
 	 */
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 	isb();
 
 	/* ... and the stage-2 MMU context that we switched away from */
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 772c1b008e437..72f10b74ce807 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -94,6 +94,7 @@ WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
 WORKAROUND_AMPERE_AC03_CPU_38
+WORKAROUND_AMPERE_AC04_CPU_23
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.49.0


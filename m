Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8E81FDA92
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757347556; cv=none; b=YpYlUwb188c9r/ciSR78iwPTpnFHTH2bXs/fFUAiPqx9w9h3xSVjWfptpZLg0NDFT07b3l4ywbhOj1j5tNBO1UI0SC9BYqGcrUaKw6izT2kmzDskYITQ5A0JhhUx50ReL9WYHss2PxdemqgYcBwFIpki0EjQZOpBMkFjt6dp5T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757347556; c=relaxed/simple;
	bh=HR2A+sxRtQ1MZ4+D8lOGcvldT5+7JqiXH/RJIElIlsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H23sOxHETzMzRuXfSkq7+sGW872MPnNR/hjCpwJIPjoLnapSXZwTa9dZwcCKHSHf2ipTQWntW/BWC8dSO+I+zMdQK4WvLiTuWnhJZ7hCVRAEfdLR8yqA0UNMOV1ihfTthjd/sTnvHwG06LnzqiCm8MBIAvwGjD3aBq1bJkwdt4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTu8lyV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTu8lyV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE95FC4CEF1;
	Mon,  8 Sep 2025 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757347555;
	bh=HR2A+sxRtQ1MZ4+D8lOGcvldT5+7JqiXH/RJIElIlsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZTu8lyV8VDYKJ6kZrxHAxacsPdjjumGoY1ayZQVmlxlNBZ8EMoC7j2h+ctAi6tCUF
	 GTE9dVwEvE625LHp1Rt912vIjqpp6aE12iS7DZ5hQppOokWLz3NL1gmlwaMqqDGNg9
	 qHdisv/jpjHrmEsQ94EEG3kgXq05hZDutEF8uHbm0iNaQ8H6727+PPMd8bhkP+j12r
	 XvH8/qpCS78wUCdLBydqn8d2asbQstMVKtmJrSgE4X9zvb5q2hb8oqd/r7Km3UWdSm
	 +Cp27TW+XHpKmzrCGKr1wLw9O6bVUJLmxV1ALj62WGvOF2fir0N23PhkG/DhzVWk1S
	 0rkhFnf4yPFEw==
Date: Mon, 8 Sep 2025 17:05:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com,
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com,
	keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v3 9/9] KVM: arm64: Reserve pKVM handle during
 pkvm_init_host_vm()
Message-ID: <1a248f14-60f2-4f8f-8b4d-3c63e602fd54@sirena.org.uk>
References: <20250827101949.4089456-1-tabba@google.com>
 <20250827101949.4089456-10-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0SN8IwTNDgVToc3e"
Content-Disposition: inline
In-Reply-To: <20250827101949.4089456-10-tabba@google.com>
X-Cookie: Danger: do not shake.


--0SN8IwTNDgVToc3e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 11:19:49AM +0100, Fuad Tabba wrote:

> When a pKVM guest is active, TLB invalidations triggered by host MMU
> notifiers require a valid hypervisor handle. Currently, this handle is
> only allocated when the first vCPU is run.

I'm seeing the KVM selftests failing in -next on multiple nVHE
platforms (pretty sure it's all of them) which bisect down to this
commit, when booted in standard nVHE mode the selftests are all failing
to initialise with:

# selftests: kvm: demand_paging_test
# Random seed: 0x6b8b4567
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   lib/arm64/processor.c:563: vm_fd >=3D 0
#   pid=3D2002 tid=3D2002 errno=3D22 - Invalid argument
#      1	0x0000000000413653: aarch64_get_supported_page_sizes at processor.=
c:563 (discriminator 3)
#      2	0x000000000040351f: guest_modes_append_default at guest_modes.c:24
#      3	0x0000ffffbeed7693: ?? ??:0
#      4	0x000000000040256f: _start at ??:?
#   KVM_CREATE_VM failed, rc: -1 errno: 22 (Invalid argument)
not ok 1 selftests: kvm: demand_paging_test # exit=3D254

Those platforms that support pKVM appear to be happy when booted with
pKVM enabled.

Sample log at:

   https://lava.sirena.org.uk/scheduler/job/1793122#L3255

The same platform with pKVM:

   https://lava.sirena.org.uk/scheduler/job/1793117#L3254

(it does OOM expectedly later on).

Bisects look like this:

# bad: [3e8e5822146bc396d2a7e5fbb7be13271665522a] Add linux-next specific f=
iles for 20250908
# good: [7c403858c49830efe946663f3000e4a25323e015] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [b497e1a1a2b10c4ddb28064fba229365ae03311a] regulator: pf530x: Add a=
 driver for the NXP PF5300 Regulator
# good: [9e5eb8b49ffe3c173bf7b8c338a57dfa09fb4634] ASoC: replace use of sys=
tem_unbound_wq with system_dfl_wq
# good: [0ccc1eeda155c947d88ef053e0b54e434e218ee2] ASoC: dt-bindings: wlf,w=
m8960: Document routing strings (pin names)
# good: [7748328c2fd82efed24257b2bfd796eb1fa1d09b] ASoC: dt-bindings: qcom,=
lpass-va-macro: Update bindings for clocks to support ADSP
# good: [dd7ae5b8b3c291c0206f127a564ae1e316705ca0] ASoC: cs42l43: Shutdown =
jack detection on suspend
# good: [5cc49b5a36b32a2dba41441ea13b93fb5ea21cfd] spi: spi-fsl-dspi: Repor=
t FIFO overflows as errors
# good: [94b39cb3ad6db935b585988b36378884199cd5fc] spi: mxs: fix "transfere=
d"->"transferred"
# good: [ce1a46b2d6a8465a86f7a6f71beb4c6de83bce5c] ASoC: codecs: lpass-wsa-=
macro: add Codev version 2.9
# good: [ce57b718006a069226b5e5d3afe7969acd59154e] ASoC: Intel: avs: ssm456=
7: Adjust platform name
# good: [3279052eab235bfb7130b1fabc74029c2260ed8d] ASoC: SOF: ipc4-topology=
: Fix a less than zero check on a u32
# good: [8f57dcf39fd0864f5f3e6701fe885e55f45d0d3a] ASoC: qcom: audioreach: =
convert to cpu endainess type before accessing
# good: [9d35d068fb138160709e04e3ee97fe29a6f8615b] regulator: scmi: Use int=
 type to store negative error codes
# good: [8a9772ec08f87c9e45ab1ad2c8d2b8c1763836eb] ASoC: soc-dapm: rename s=
nd_soc_kcontrol_component() to snd_soc_kcontrol_to_component()
# good: [3d439e1ec3368fae17db379354bd7a9e568ca0ab] ASoC: sof: ipc4-topology=
: Add support to sched_domain attribute
# good: [5c39bc498f5ff7ef016abf3f16698f3e8db79677] ASoC: SOF: Intel: only d=
etect codecs when HDA DSP probe
# good: [07752abfa5dbf7cb4d9ce69fa94dc3b12bc597d9] ASoC: SOF: sof-client: I=
ntroduce sof_client_dev_entry structure
# good: [f522da9ab56c96db8703b2ea0f09be7cdc3bffeb] ASoC: doc: Internally li=
nk to Writing an ALSA Driver docs
# good: [f7c41911ad744177d8289820f01009dc93d8f91c] ASoC: SOF: ipc4-topology=
: Add support for float sample type
# good: [d57d27171c92e9049d5301785fb38de127b28fbf] ASoC: SOF: sof-client-pr=
obes: Add available points_info(), IPC4 only
# good: [f4672dc6e9c07643c8c755856ba8e9eb9ca95d0c] regmap: use int type to =
store negative error codes
# good: [11f5c5f9e43e9020bae452232983fe98e7abfce0] ASoC: qcom: use int type=
 to store negative error codes
# good: [899fb38dd76dd3ede425bbaf8a96d390180a5d1c] regulator: core: Remove =
redundant ternary operators
# good: [5b4dcaf851df8c414bfc2ac3bf9c65fc942f3be4] ASoC: amd: acp: Remove (=
explicitly) unused header
# good: [c42e36a488c7e01f833fc9f4814f735b66b2d494] spi: Drop dev_pm_domain_=
detach() call
# good: [a37280daa4d583c7212681c49b285de9464a5200] ASoC: Intel: avs: Allow =
i2s test and non-test boards to coexist
# good: [b088b6189a4066b97cef459afd312fd168a76dea] ASoC: mediatek: common: =
Switch to for_each_available_child_of_node_scoped()
# good: [ff9a7857b7848227788f113d6dc6a72e989084e0] spi: rb4xx: use devm for=
 clk_prepare_enable
# good: [edb5c1f885207d1d74e8a1528e6937e02829ee6e] ASoC: renesas: msiof: st=
art DMAC first
# good: [e2ab5f600bb01d3625d667d97b3eb7538e388336] rust: regulator: use `to=
_result` for error handling
# good: [a12b74d2bd4724ee1883bc97ec93eac8fafc8d3c] ASoC: tlv320aic32x4: use=
 dev_err_probe() for regulators
# good: [f840737d1746398c2993be34bfdc80bdc19ecae2] ASoC: SOF: imx: Remove t=
he use of dev_err_probe()
# good: [d78e48ebe04e9566f8ecbf51471e80da3adbceeb] ASoC: dt-bindings: Minor=
 whitespace cleanup in example
# good: [96bcb34df55f7fee99795127c796315950c94fed] ASoC: test-component: Us=
e kcalloc() instead of kzalloc()
# good: [c232495d28ca092d0c39b10e35d3d613bd2414ab] ASoC: dt-bindings: omap-=
twl4030: convert to DT schema
# good: [ec0be3cdf40b5302248f3fb27a911cc630e8b855] regulator: consumer.rst:=
 document bulk operations
# good: [27848c082ba0b22850fd9fb7b185c015423dcdc7] spi: s3c64xx: Remove the=
 use of dev_err_probe()
# good: [c1dd310f1d76b4b13f1854618087af2513140897] spi: SPISG: Use devm_kca=
lloc() in aml_spisg_clk_init()
# good: [da9881d00153cc6d3917f6b74144b1d41b58338c] ASoC: qcom: audioreach: =
add support for SMECNS module
# good: [cf65182247761f7993737b710afe8c781699356b] ASoC: codecs: wsa883x: H=
andle shared reset GPIO for WSA883x speakers
# good: [2a55135201d5e24b80b7624880ff42eafd8e320c] ASoC: Intel: avs: Stream=
line register-component function names
# good: [550bc517e59347b3b1af7d290eac4fb1411a3d4e] regulator: bd718x7: Use =
kcalloc() instead of kzalloc()
# good: [daf855f76a1210ceed9541f71ac5dd9be02018a6] ASoC: es8323: enable DAP=
M power widgets for playback DAC
# good: [0056b410355713556d8a10306f82e55b28d33ba8] spi: offload trigger: ad=
i-util-sigma-delta: clean up imports
# good: [90179609efa421b1ccc7d8eafbc078bafb25777c] spi: spl022: use min_t()=
 to improve code
# good: [258384d8ce365dddd6c5c15204de8ccd53a7ab0a] ASoC: es8323: enable DAP=
M power widgets for playback DAC and output
# good: [6d068f1ae2a2f713d7f21a9a602e65b3d6b6fc6d] regulator: rt5133: Fix s=
pelling mistake "regualtor" -> "regulator"
# good: [a46e95c81e3a28926ab1904d9f754fef8318074d] ASoC: wl1273: Remove
# good: [48124569bbc6bfda1df3e9ee17b19d559f4b1aa3] spi: remove unneeded 'fa=
st_io' parameter in regmap_config
# good: [0e62438e476494a1891a8822b9785bc6e73e9c3f] ASoC: Intel: sst: Remove=
 redundant semicolons
# good: [37533933bfe92cd5a99ef4743f31dac62ccc8de0] regulator: remove unneed=
ed 'fast_io' parameter in regmap_config
# good: [5c36b86d2bf68fbcad16169983ef7ee8c537db59] regmap: Remove superfluo=
us check for !config in __regmap_init()
# good: [714165e1c4b0d5b8c6d095fe07f65e6e7047aaeb] regulator: rt5133: Add R=
T5133 PMIC regulator Support
# good: [9c45f95222beecd6a284fd1284d54dd7a772cf59] spi: spi-qpic-snand: han=
dle 'use_ecc' parameter of qcom_spi_config_cw_read()
# good: [b832b19318534bb4f1673b24d78037fee339c679] spi: loopback-test: Don'=
t use %pK through printk
# good: [bab4ab484a6ca170847da9bffe86f1fa90df4bbe] ASoC: dt-bindings: Conve=
rt brcm,bcm2835-i2s to DT schema
# good: [8c02c8353460f8630313aef6810f34e134a3c1ee] ASoC: dt-bindings: realt=
ek,alc5623: convert to DT schema
# good: [6b7e2aa50bdaf88cd4c2a5e2059a7bf32d85a8b1] spi: spi-qpic-snand: rem=
ove 'clr*status' members of struct 'qpic_ecc'
# good: [2291a2186305faaf8525d57849d8ba12ad63f5e7] MAINTAINERS: Add entry f=
or FourSemi audio amplifiers
# good: [a54ef14188519a0994d0264f701f5771815fa11e] regulator: dt-bindings: =
Clean-up active-semi,act8945a duplication
# good: [a1d0b0ae65ae3f32597edfbb547f16c75601cd87] spi: spi-qpic-snand: avo=
id double assignment in qcom_spi_probe()
# good: [3059067fd3378a5454e7928c08d20bf3ef186760] ASoC: cs48l32: Use PTR_E=
RR_OR_ZERO() to simplify code
# good: [2d86d2585ab929a143d1e6f8963da1499e33bf13] ASoC: pxa: add GPIOLIB_L=
EGACY dependency
# good: [9a200cbdb54349909a42b45379e792e4b39dd223] rust: regulator: impleme=
nt Send and Sync for Regulator<T>
# good: [162e23657e5379f07c6404dbfbf4367cb438ea7d] regulator: pf0900: Add P=
MIC PF0900 support
# good: [886f42ce96e7ce80545704e7168a9c6b60cd6c03] regmap: mmio: Add missin=
g MODULE_DESCRIPTION()
# good: [cf25eb8eae91bcae9b2065d84b0c0ba0f6d9dd34] ASoC: soc-component: unp=
ack snd_soc_component_init_bias_level()
# good: [595b7f155b926460a00776cc581e4dcd01220006] ASoC: Intel: avs: Condit=
ional-path support
git bisect start '3e8e5822146bc396d2a7e5fbb7be13271665522a' '7c403858c49830=
efe946663f3000e4a25323e015' 'b497e1a1a2b10c4ddb28064fba229365ae03311a' '9e5=
eb8b49ffe3c173bf7b8c338a57dfa09fb4634' '0ccc1eeda155c947d88ef053e0b54e434e2=
18ee2' '7748328c2fd82efed24257b2bfd796eb1fa1d09b' 'dd7ae5b8b3c291c0206f127a=
564ae1e316705ca0' '5cc49b5a36b32a2dba41441ea13b93fb5ea21cfd' '94b39cb3ad6db=
935b585988b36378884199cd5fc' 'ce1a46b2d6a8465a86f7a6f71beb4c6de83bce5c' 'ce=
57b718006a069226b5e5d3afe7969acd59154e' '3279052eab235bfb7130b1fabc74029c22=
60ed8d' '8f57dcf39fd0864f5f3e6701fe885e55f45d0d3a' '9d35d068fb138160709e04e=
3ee97fe29a6f8615b' '8a9772ec08f87c9e45ab1ad2c8d2b8c1763836eb' '3d439e1ec336=
8fae17db379354bd7a9e568ca0ab' '5c39bc498f5ff7ef016abf3f16698f3e8db79677' '0=
7752abfa5dbf7cb4d9ce69fa94dc3b12bc597d9' 'f522da9ab56c96db8703b2ea0f09be7cd=
c3bffeb' 'f7c41911ad744177d8289820f01009dc93d8f91c' 'd57d27171c92e9049d5301=
785fb38de127b28fbf' 'f4672dc6e9c07643c8c755856ba8e9eb9ca95d0c' '11f5c5f9e43=
e9020bae452232983fe98e7abfce0' '899fb38dd76dd3ede425bbaf8a96d390180a5d1c' '=
5b4dcaf851df8c414bfc2ac3bf9c65fc942f3be4' 'c42e36a488c7e01f833fc9f4814f735b=
66b2d494' 'a37280daa4d583c7212681c49b285de9464a5200' 'b088b6189a4066b97cef4=
59afd312fd168a76dea' 'ff9a7857b7848227788f113d6dc6a72e989084e0' 'edb5c1f885=
207d1d74e8a1528e6937e02829ee6e' 'e2ab5f600bb01d3625d667d97b3eb7538e388336' =
'a12b74d2bd4724ee1883bc97ec93eac8fafc8d3c' 'f840737d1746398c2993be34bfdc80b=
dc19ecae2' 'd78e48ebe04e9566f8ecbf51471e80da3adbceeb' '96bcb34df55f7fee9979=
5127c796315950c94fed' 'c232495d28ca092d0c39b10e35d3d613bd2414ab' 'ec0be3cdf=
40b5302248f3fb27a911cc630e8b855' '27848c082ba0b22850fd9fb7b185c015423dcdc7'=
 'c1dd310f1d76b4b13f1854618087af2513140897' 'da9881d00153cc6d3917f6b74144b1=
d41b58338c' 'cf65182247761f7993737b710afe8c781699356b' '2a55135201d5e24b80b=
7624880ff42eafd8e320c' '550bc517e59347b3b1af7d290eac4fb1411a3d4e' 'daf855f7=
6a1210ceed9541f71ac5dd9be02018a6' '0056b410355713556d8a10306f82e55b28d33ba8=
' '90179609efa421b1ccc7d8eafbc078bafb25777c' '258384d8ce365dddd6c5c15204de8=
ccd53a7ab0a' '6d068f1ae2a2f713d7f21a9a602e65b3d6b6fc6d' 'a46e95c81e3a28926a=
b1904d9f754fef8318074d' '48124569bbc6bfda1df3e9ee17b19d559f4b1aa3' '0e62438=
e476494a1891a8822b9785bc6e73e9c3f' '37533933bfe92cd5a99ef4743f31dac62ccc8de=
0' '5c36b86d2bf68fbcad16169983ef7ee8c537db59' '714165e1c4b0d5b8c6d095fe07f6=
5e6e7047aaeb' '9c45f95222beecd6a284fd1284d54dd7a772cf59' 'b832b19318534bb4f=
1673b24d78037fee339c679' 'bab4ab484a6ca170847da9bffe86f1fa90df4bbe' '8c02c8=
353460f8630313aef6810f34e134a3c1ee' '6b7e2aa50bdaf88cd4c2a5e2059a7bf32d85a8=
b1' '2291a2186305faaf8525d57849d8ba12ad63f5e7' 'a54ef14188519a0994d0264f701=
f5771815fa11e' 'a1d0b0ae65ae3f32597edfbb547f16c75601cd87' '3059067fd3378a54=
54e7928c08d20bf3ef186760' '2d86d2585ab929a143d1e6f8963da1499e33bf13' '9a200=
cbdb54349909a42b45379e792e4b39dd223' '162e23657e5379f07c6404dbfbf4367cb438e=
a7d' '886f42ce96e7ce80545704e7168a9c6b60cd6c03' 'cf25eb8eae91bcae9b2065d84b=
0c0ba0f6d9dd34' '595b7f155b926460a00776cc581e4dcd01220006'
# test job: [b497e1a1a2b10c4ddb28064fba229365ae03311a] https://lava.sirena.=
org.uk/scheduler/job/1780201
# test job: [9e5eb8b49ffe3c173bf7b8c338a57dfa09fb4634] https://lava.sirena.=
org.uk/scheduler/job/1779453
# test job: [0ccc1eeda155c947d88ef053e0b54e434e218ee2] https://lava.sirena.=
org.uk/scheduler/job/1773053
# test job: [7748328c2fd82efed24257b2bfd796eb1fa1d09b] https://lava.sirena.=
org.uk/scheduler/job/1773389
# test job: [dd7ae5b8b3c291c0206f127a564ae1e316705ca0] https://lava.sirena.=
org.uk/scheduler/job/1773238
# test job: [5cc49b5a36b32a2dba41441ea13b93fb5ea21cfd] https://lava.sirena.=
org.uk/scheduler/job/1769279
# test job: [94b39cb3ad6db935b585988b36378884199cd5fc] https://lava.sirena.=
org.uk/scheduler/job/1768591
# test job: [ce1a46b2d6a8465a86f7a6f71beb4c6de83bce5c] https://lava.sirena.=
org.uk/scheduler/job/1768999
# test job: [ce57b718006a069226b5e5d3afe7969acd59154e] https://lava.sirena.=
org.uk/scheduler/job/1768701
# test job: [3279052eab235bfb7130b1fabc74029c2260ed8d] https://lava.sirena.=
org.uk/scheduler/job/1762406
# test job: [8f57dcf39fd0864f5f3e6701fe885e55f45d0d3a] https://lava.sirena.=
org.uk/scheduler/job/1760077
# test job: [9d35d068fb138160709e04e3ee97fe29a6f8615b] https://lava.sirena.=
org.uk/scheduler/job/1758648
# test job: [8a9772ec08f87c9e45ab1ad2c8d2b8c1763836eb] https://lava.sirena.=
org.uk/scheduler/job/1758574
# test job: [3d439e1ec3368fae17db379354bd7a9e568ca0ab] https://lava.sirena.=
org.uk/scheduler/job/1753456
# test job: [5c39bc498f5ff7ef016abf3f16698f3e8db79677] https://lava.sirena.=
org.uk/scheduler/job/1751966
# test job: [07752abfa5dbf7cb4d9ce69fa94dc3b12bc597d9] https://lava.sirena.=
org.uk/scheduler/job/1752245
# test job: [f522da9ab56c96db8703b2ea0f09be7cdc3bffeb] https://lava.sirena.=
org.uk/scheduler/job/1751839
# test job: [f7c41911ad744177d8289820f01009dc93d8f91c] https://lava.sirena.=
org.uk/scheduler/job/1752348
# test job: [d57d27171c92e9049d5301785fb38de127b28fbf] https://lava.sirena.=
org.uk/scheduler/job/1752655
# test job: [f4672dc6e9c07643c8c755856ba8e9eb9ca95d0c] https://lava.sirena.=
org.uk/scheduler/job/1747890
# test job: [11f5c5f9e43e9020bae452232983fe98e7abfce0] https://lava.sirena.=
org.uk/scheduler/job/1747496
# test job: [899fb38dd76dd3ede425bbaf8a96d390180a5d1c] https://lava.sirena.=
org.uk/scheduler/job/1747402
# test job: [5b4dcaf851df8c414bfc2ac3bf9c65fc942f3be4] https://lava.sirena.=
org.uk/scheduler/job/1747656
# test job: [c42e36a488c7e01f833fc9f4814f735b66b2d494] https://lava.sirena.=
org.uk/scheduler/job/1746376
# test job: [a37280daa4d583c7212681c49b285de9464a5200] https://lava.sirena.=
org.uk/scheduler/job/1746906
# test job: [b088b6189a4066b97cef459afd312fd168a76dea] https://lava.sirena.=
org.uk/scheduler/job/1746166
# test job: [ff9a7857b7848227788f113d6dc6a72e989084e0] https://lava.sirena.=
org.uk/scheduler/job/1746349
# test job: [edb5c1f885207d1d74e8a1528e6937e02829ee6e] https://lava.sirena.=
org.uk/scheduler/job/1746184
# test job: [e2ab5f600bb01d3625d667d97b3eb7538e388336] https://lava.sirena.=
org.uk/scheduler/job/1746599
# test job: [a12b74d2bd4724ee1883bc97ec93eac8fafc8d3c] https://lava.sirena.=
org.uk/scheduler/job/1734072
# test job: [f840737d1746398c2993be34bfdc80bdc19ecae2] https://lava.sirena.=
org.uk/scheduler/job/1727354
# test job: [d78e48ebe04e9566f8ecbf51471e80da3adbceeb] https://lava.sirena.=
org.uk/scheduler/job/1706152
# test job: [96bcb34df55f7fee99795127c796315950c94fed] https://lava.sirena.=
org.uk/scheduler/job/1699511
# test job: [c232495d28ca092d0c39b10e35d3d613bd2414ab] https://lava.sirena.=
org.uk/scheduler/job/1699598
# test job: [ec0be3cdf40b5302248f3fb27a911cc630e8b855] https://lava.sirena.=
org.uk/scheduler/job/1694317
# test job: [27848c082ba0b22850fd9fb7b185c015423dcdc7] https://lava.sirena.=
org.uk/scheduler/job/1693086
# test job: [c1dd310f1d76b4b13f1854618087af2513140897] https://lava.sirena.=
org.uk/scheduler/job/1693032
# test job: [da9881d00153cc6d3917f6b74144b1d41b58338c] https://lava.sirena.=
org.uk/scheduler/job/1693403
# test job: [cf65182247761f7993737b710afe8c781699356b] https://lava.sirena.=
org.uk/scheduler/job/1687534
# test job: [2a55135201d5e24b80b7624880ff42eafd8e320c] https://lava.sirena.=
org.uk/scheduler/job/1685792
# test job: [550bc517e59347b3b1af7d290eac4fb1411a3d4e] https://lava.sirena.=
org.uk/scheduler/job/1685918
# test job: [daf855f76a1210ceed9541f71ac5dd9be02018a6] https://lava.sirena.=
org.uk/scheduler/job/1685494
# test job: [0056b410355713556d8a10306f82e55b28d33ba8] https://lava.sirena.=
org.uk/scheduler/job/1685628
# test job: [90179609efa421b1ccc7d8eafbc078bafb25777c] https://lava.sirena.=
org.uk/scheduler/job/1686051
# test job: [258384d8ce365dddd6c5c15204de8ccd53a7ab0a] https://lava.sirena.=
org.uk/scheduler/job/1673408
# test job: [6d068f1ae2a2f713d7f21a9a602e65b3d6b6fc6d] https://lava.sirena.=
org.uk/scheduler/job/1673152
# test job: [a46e95c81e3a28926ab1904d9f754fef8318074d] https://lava.sirena.=
org.uk/scheduler/job/1673768
# test job: [48124569bbc6bfda1df3e9ee17b19d559f4b1aa3] https://lava.sirena.=
org.uk/scheduler/job/1670210
# test job: [0e62438e476494a1891a8822b9785bc6e73e9c3f] https://lava.sirena.=
org.uk/scheduler/job/1669526
# test job: [37533933bfe92cd5a99ef4743f31dac62ccc8de0] https://lava.sirena.=
org.uk/scheduler/job/1668990
# test job: [5c36b86d2bf68fbcad16169983ef7ee8c537db59] https://lava.sirena.=
org.uk/scheduler/job/1667991
# test job: [714165e1c4b0d5b8c6d095fe07f65e6e7047aaeb] https://lava.sirena.=
org.uk/scheduler/job/1667724
# test job: [9c45f95222beecd6a284fd1284d54dd7a772cf59] https://lava.sirena.=
org.uk/scheduler/job/1667627
# test job: [b832b19318534bb4f1673b24d78037fee339c679] https://lava.sirena.=
org.uk/scheduler/job/1659223
# test job: [bab4ab484a6ca170847da9bffe86f1fa90df4bbe] https://lava.sirena.=
org.uk/scheduler/job/1664672
# test job: [8c02c8353460f8630313aef6810f34e134a3c1ee] https://lava.sirena.=
org.uk/scheduler/job/1659271
# test job: [6b7e2aa50bdaf88cd4c2a5e2059a7bf32d85a8b1] https://lava.sirena.=
org.uk/scheduler/job/1656579
# test job: [2291a2186305faaf8525d57849d8ba12ad63f5e7] https://lava.sirena.=
org.uk/scheduler/job/1655751
# test job: [a54ef14188519a0994d0264f701f5771815fa11e] https://lava.sirena.=
org.uk/scheduler/job/1656029
# test job: [a1d0b0ae65ae3f32597edfbb547f16c75601cd87] https://lava.sirena.=
org.uk/scheduler/job/1654220
# test job: [3059067fd3378a5454e7928c08d20bf3ef186760] https://lava.sirena.=
org.uk/scheduler/job/1654017
# test job: [2d86d2585ab929a143d1e6f8963da1499e33bf13] https://lava.sirena.=
org.uk/scheduler/job/1654161
# test job: [9a200cbdb54349909a42b45379e792e4b39dd223] https://lava.sirena.=
org.uk/scheduler/job/1654732
# test job: [162e23657e5379f07c6404dbfbf4367cb438ea7d] https://lava.sirena.=
org.uk/scheduler/job/1652997
# test job: [886f42ce96e7ce80545704e7168a9c6b60cd6c03] https://lava.sirena.=
org.uk/scheduler/job/1654276
# test job: [cf25eb8eae91bcae9b2065d84b0c0ba0f6d9dd34] https://lava.sirena.=
org.uk/scheduler/job/1654780
# test job: [595b7f155b926460a00776cc581e4dcd01220006] https://lava.sirena.=
org.uk/scheduler/job/1653846
# test job: [3e8e5822146bc396d2a7e5fbb7be13271665522a] https://lava.sirena.=
org.uk/scheduler/job/1793153
# bad: [3e8e5822146bc396d2a7e5fbb7be13271665522a] Add linux-next specific f=
iles for 20250908
git bisect bad 3e8e5822146bc396d2a7e5fbb7be13271665522a
# test job: [bc7550204de94f6101310fb8095f708c285431ca] https://lava.sirena.=
org.uk/scheduler/job/1793315
# good: [bc7550204de94f6101310fb8095f708c285431ca] Merge branch 'for-next' =
of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.g=
it
git bisect good bc7550204de94f6101310fb8095f708c285431ca
# test job: [f89a60b3d8622fb88dad53ffe7b14ea06a43d99b] https://lava.sirena.=
org.uk/scheduler/job/1793443
# good: [f89a60b3d8622fb88dad53ffe7b14ea06a43d99b] Merge branch 'next' of h=
ttps://github.com/cschaufler/smack-next
git bisect good f89a60b3d8622fb88dad53ffe7b14ea06a43d99b
# test job: [780f5a8e290e1ca7617c9dbe7d7b710d53f4cce5] https://lava.sirena.=
org.uk/scheduler/job/1793634
# bad: [780f5a8e290e1ca7617c9dbe7d7b710d53f4cce5] Merge branch 'for-next' o=
f https://git.kernel.org/pub/scm/linux/kernel/git/srini/fastrpc.git
git bisect bad 780f5a8e290e1ca7617c9dbe7d7b710d53f4cce5
# test job: [7ed2bb10a0de5537f4cb36e83b83ff082d26e780] https://lava.sirena.=
org.uk/scheduler/job/1793681
# good: [7ed2bb10a0de5537f4cb36e83b83ff082d26e780] Merge branch 'for-next' =
of https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace.git
git bisect good 7ed2bb10a0de5537f4cb36e83b83ff082d26e780
# test job: [27e2ff3bef6e7de460cd313aad3567dcab67b162] https://lava.sirena.=
org.uk/scheduler/job/1793789
# bad: [27e2ff3bef6e7de460cd313aad3567dcab67b162] Merge branch 'for-next' o=
f https://github.com/cminyard/linux-ipmi.git
git bisect bad 27e2ff3bef6e7de460cd313aad3567dcab67b162
# test job: [11df090ea4a7f486f23d1963fda10e183e5387ab] https://lava.sirena.=
org.uk/scheduler/job/1793980
# bad: [11df090ea4a7f486f23d1963fda10e183e5387ab] Merge branch 'next' of ht=
tps://github.com/kvm-x86/linux.git
git bisect bad 11df090ea4a7f486f23d1963fda10e183e5387ab
# test job: [25d1af407bbb88d464dab60641d8b86b82ede938] https://lava.sirena.=
org.uk/scheduler/job/1794155
# good: [25d1af407bbb88d464dab60641d8b86b82ede938] Merge branch 'next' of g=
it://git.kernel.org/pub/scm/virt/kvm/kvm.git
git bisect good 25d1af407bbb88d464dab60641d8b86b82ede938
# test job: [41f6710f99f4337924e3929e8e7a51c74f800b91] https://lava.sirena.=
org.uk/scheduler/job/1794187
# good: [41f6710f99f4337924e3929e8e7a51c74f800b91] KVM: x86: Manually clear=
 MPX state only on INIT
git bisect good 41f6710f99f4337924e3929e8e7a51c74f800b91
# test job: [ecbcc2461839e848970468b44db32282e5059925] https://lava.sirena.=
org.uk/scheduler/job/1794248
# good: [ecbcc2461839e848970468b44db32282e5059925] Merge branches 'fixes', =
'generic', 'misc', 'mmu', 'selftests', 'svm' and 'vmx'
git bisect good ecbcc2461839e848970468b44db32282e5059925
# test job: [35e66e8a4b225f570e8283ff22654f3f1e3cd37d] https://lava.sirena.=
org.uk/scheduler/job/1794299
# good: [35e66e8a4b225f570e8283ff22654f3f1e3cd37d] KVM: arm64: Consolidate =
pKVM hypervisor VM initialization logic
git bisect good 35e66e8a4b225f570e8283ff22654f3f1e3cd37d
# test job: [ab57bbf321e1b58007056bf4da91b05f931b2353] https://lava.sirena.=
org.uk/scheduler/job/1794346
# bad: [ab57bbf321e1b58007056bf4da91b05f931b2353] Merge branch kvm-arm64/pk=
vm_vm_handle into kvmarm-master/next
git bisect bad ab57bbf321e1b58007056bf4da91b05f931b2353
# test job: [ebe37eefb309cdd23edc131901ffce75cbcb3541] https://lava.sirena.=
org.uk/scheduler/job/1794408
# bad: [ebe37eefb309cdd23edc131901ffce75cbcb3541] KVM: arm64: Reserve pKVM =
handle during pkvm_init_host_vm()
git bisect bad ebe37eefb309cdd23edc131901ffce75cbcb3541
# test job: [f677b5ead216987c85b9c7da4e4dbce5f3725cf2] https://lava.sirena.=
org.uk/scheduler/job/1794459
# good: [f677b5ead216987c85b9c7da4e4dbce5f3725cf2] KVM: arm64: Introduce se=
parate hypercalls for pKVM VM reservation and initialization
git bisect good f677b5ead216987c85b9c7da4e4dbce5f3725cf2
# first bad commit: [ebe37eefb309cdd23edc131901ffce75cbcb3541] KVM: arm64: =
Reserve pKVM handle during pkvm_init_host_vm()

--0SN8IwTNDgVToc3e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi+/t0ACgkQJNaLcl1U
h9B7Lgf/dZSX+XSP2L4q+8hD7p30mkVGR91laY6G54GguRpu0TrxDnk3mQ5hKSVn
y8y2GtdoLHoAcub5bQphKcQ670WnCPiZZmvbNaUxTWF5+ieotjmJ+GUjnsItBz4h
Dk7goY+BqHRcs9FiMB4YmoQlVmQ1Wr8D9mVoZmLbZtcmRYTGEpvpftejisYh+9oh
nVE3fy/JqtLb/8ip8939B3zKur3XeUfdNls6gB5kGtQCbUVxecQuM4eGb/hdj+OT
6WQjAOr1jYweMDTN4eSbV6U5PwAt/U2BM0BcuD8cr6G8OCPqJF4OUTXe+36+FcAk
QZN/PIFJCZ34Na/+9qyrSAKZNCZ++g==
=NjTd
-----END PGP SIGNATURE-----

--0SN8IwTNDgVToc3e--

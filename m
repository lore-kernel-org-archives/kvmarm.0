Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745319DF52
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 20:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740688765; cv=none; b=a5rrSxxlD6ggklwbLq4/StZSBbABCE1gWX3xluRpWSgy0y1eL0u/mB6fld0c/mgWcZHKNUEPfRLZGHcbcNZnMNiFlHYKlvKEDSl7QwyihCJtM9rQopQLmXnQrmQ181Hv4+uUJjluFfUUozB3l8Bc4IaE8ikziPcFH7LIYfGvsxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740688765; c=relaxed/simple;
	bh=gtPs3JeJiVHqLse0nT/i6emUR3GHAvOvUnvEA2IUdM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfgTJrrMKtloNHev/I2Pe0TqA36pApgH4i5MPlkWbEDJtQ6G6K5JklCNp1mELoclSvNe6cmP7MnKJXw1tAkSYljl0clZbFY2UlwmcafcTVJrXmq8tNspyLqB0iOAFiTR4ujmk4pnXzrJzv0j4YLhGym4e9tpGKMWmAkCkAnuEvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6qYuWJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6qYuWJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4724C4CEDD;
	Thu, 27 Feb 2025 20:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740688765;
	bh=gtPs3JeJiVHqLse0nT/i6emUR3GHAvOvUnvEA2IUdM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z6qYuWJboKWYPefLQHnFDBXsYyP8akOmhnjZjpiwQR/2jTS1uAQm2F2iKgGflUbdm
	 +whSGFZxyB4UKRaDzITSUdUwScFIxNyej0vT2GhfY43o0uxJsC9xjlyR9c6sHjKs+V
	 z9vzrL+kNGbJ3Ls7pjSO/VVCL1GjI891l8Hs8t1/c77eU8Wrq69CG76qOeXL8J556K
	 jYGObELdiIV7yWOoJbv7gLGklhc3JCTXbZaEvhRESLYtYjIdV3v+/BhlVwDAaiownO
	 y/Xa7wi0Vf7MF4B33qylWuk8ehsoa2flZf1ibBlmeQe0nfkNTUEtEcVHcAxWxvu0CQ
	 ydiptkuSoIkbg==
Date: Thu, 27 Feb 2025 20:39:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v4 5/5] KVM: selftests: arm64: Test writes to
 MIDR,REVIDR,AIDR
Message-ID: <ac594b9c-4bbb-46c8-9391-e7a68ce4de5b@sirena.org.uk>
References: <20250225005401.679536-1-oliver.upton@linux.dev>
 <20250225005401.679536-6-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hnaM5YX/Z+WWtRrK"
Content-Disposition: inline
In-Reply-To: <20250225005401.679536-6-oliver.upton@linux.dev>
X-Cookie: Keep on keepin' on.


--hnaM5YX/Z+WWtRrK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 04:54:01PM -0800, Oliver Upton wrote:

> Assert that MIDR_EL1, REVIDR_EL1, AIDR_EL1 are writable from userspace,
> that the changed values are visible to guests, and that they are
> preserved across a vCPU reset.

This newly added test fails with pKVM on every platform I've looked at:

# ok 92 ID_AA64PFR1_EL1.MPAM_frac not arbitrarily modifiable
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   arm64/set_id_regs.c:557: test_reg_vals[encoding_to_range_idx(uc.args[2]=
)] =3D=3D uc.args[3]
#   pid=3D3711 tid=3D3711 errno=3D4 - Interrupted system call
#      1	0x000000000040287f: test_guest_reg_read at set_id_regs.c:557
#      2	0x0000000000401df3: main at set_id_regs.c:710
#      3	0x0000ffff9b207543: ?? ??:0
#      4	0x0000ffff9b207617: ?? ??:0
#      5	0x000000000040206f: _start at ??:?
#   0x410fd035 !=3D 0 (test_reg_vals[encoding_to_range_idx(uc.args[2])] !=
=3D uc.args[3])
not ok 8 selftests: kvm: set_id_regs # exit=3D254

Full log:

   https://lava.sirena.org.uk/scheduler/job/1148551

# bad: [be5c7bbb3a64baf884481a1ba0c2f8fb2f93f7c3] Add linux-next specific f=
iles for 20250227
# good: [26ae3358dc4d3dfb1c449871840de41ef9ac3aa6] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [be1e3607f29a5a182eaa70e3058aef32fd0cc4f8] ASoC: tas2781: Clean up =
for some define
# good: [62142da241a08006f89b0620f7291e3a08c0a094] ASoC: rt712-sdca: Add FU=
05 playback switch control
# good: [1d2e01d53a8ebfffb49e8cc656f8c85239121b26] spi: spi-imx: convert ti=
meouts to secs_to_jiffies()
# good: [55a1abd6e76ce91eb6049f32efec3a8506686748] MAINTAINERS: Add Vincenz=
o Frascino as Xilinx Sound Driver Maintainer
# good: [f00b3056843d14754ac1bab2106cf5599680f115] ASoC: dt-bindings: media=
tek,mt8188-mt6359: Add DMIC backend to dai-link
# good: [3e7b375752b5e4de56e92dfb9c43309cd985b869] ASoC: dt-bindings: fsl,i=
mx-asrc: Reference common DAI properties
# good: [8fd0e127d8da856e34391399df40b33af2b307e0] ASoC: amd: acp: acp70: R=
emove unnecessary if-check
# good: [0dffacbbf8d044456d50c893adb9499775c489f4] regulator: Add (devm_)of=
_regulator_get()
# good: [1877c3e7937fb2b9373ba263a4900448d50917b7] ASoC: imx-card: Add play=
back_only or capture_only support
# good: [a9409fcb979eaff401837b955b234ca1ee05fdbd] ASoC: Intel: avs: Suppor=
t multi-channel PEAKVOL instantiation
# good: [10efa807929084a8a1c38655942a3bf83bce587a] ASoC: cros_ec_codec: Use=
 str_enable_disable() helper in wov_enable_put()
# good: [97673ea38a77e42eaafcf5181c84f6c8d40b97e7] gpio: regmap: Group opti=
onal assignments together for better understanding
# good: [375790f18396b2ba706e031b150c58cd37b45a11] gpiolib: Extract gpiochi=
p_choose_fwnode() for wider use
# good: [db305161880a024a43f4b1cbafa7a294793d7a9e] gpio: regmap: Allow ngpi=
o to be read from the property
# good: [369552fd03f296261023872b8fc983d1fc55c8e9] Merge patch series "mpt3=
sas driver udpates"
# good: [b47834ee4485bbdcc6d36f086ff61c3efd8870d4] ASoC: SOF: amd: Add depe=
nds on CPU_SUP_AMD
# good: [f3bfa0f07976a7996b6dedba21d2e0d164f08ce8] spi: dt-bindings: Conver=
t Freescale SPI bindings to YAML
# good: [64899904d6103500ad01be7b763298dc939285ae] ASoC: soc-core: Use str_=
yes_no() in snd_soc_close_delayed_work()
# good: [42ae6e2559e63c2d4096b698cd47aaeb974436df] firmware: cs_dsp: test_c=
ontrol_parse: null-terminate test strings
# good: [cb15abd47806b449e853caf43f41573c4c82fed3] spi: s3c64xx: extend des=
cription of compatible's fifo_depth
# good: [66d8e76e8e85a30fbf9809837e07e15a8c5ccb8b] regulator: pca9450: Remo=
ve duplicate code in probe
# good: [c8d08464bce947ee060e0174a3f4e87503269d0c] ASoC: dt-bindings: atmel=
-at91sam9g20ek: convert to json-schema
# good: [a261d77fec147b9974aacca8ae8f0693feede838] ASoC: SOF: amd: Drop hos=
t bridge ID from struct
# good: [c893ee3f95f16fcb98da934d61483d0b7d8ed568] x86/amd_node: Add a smn_=
read_register() helper
# good: [d1a09c610027e446ed30c21f61c2f2443bf92a3f] MAINTAINERS: adjust the =
file entry in SPI OFFLOAD
# good: [5d9fca12f54d3e25e02521aa8f3ec5d53759b334] ASoC: amd: ps: fix incon=
sistent indenting warning in check_and_handle_sdw_dma_irq()
# good: [d5d9e982a0886a1a99a1a8ef5320c57e257b4fb0] nvmem: core: fix bit off=
sets of more than one byte
# good: [eca73df072715efb5e880514bb8395e0a4e74a59] nvmem: core: update raw_=
len if the bit reading is required
# good: [4770132f37dbf327d25455d226e54fafbef6a5c4] nvmem: qfprom: switch to=
 4-byte aligned reads
# good: [11ccaa3121119eeff9ab9d537e0cf6be3b10698b] nvmem: core: verify cell=
's raw_len
# good: [73dad3ec96ae3f2da947ff0396c2910bd73f00a2] iio: dummy: Stop using i=
io_device_claim_direct_scoped()
# good: [8a1812d040c0059378fe8687d68a8b6a90493de1] iio: adc: ad7606: Stop u=
sing iio_device_claim_direct_scoped()
# good: [a927e72925c7a8aa2a1cf330c09ce13f4e5b1120] iio: amplifiers: hmc425a=
: use gpiod_multi_set_value_cansleep
# good: [b2108fc82a0acda34388bff3e3ee3544013b1623] drm: Move for_each_if() =
to util_macros.h for wider use
# good: [3419bdfd88e314bc5f80b02fa4651c81a0a85b57] dt-bindings: nvmem: qfpr=
om: Add X1E80100 compatible
# good: [e08fe24c34d37d00e84009f2fb4c35f5978041e6] ASoC: SOF: Intel: Use st=
r_enable_disable() helper
# good: [d64c4c3d1c578f98d70db1c5e2535b47adce9d07] ASoC: tas2764: Add reg d=
efaults for TAS2764_INT_CLK_CFG
# good: [42da18e62652b58ba5ecd1524c146b202cda9bb7] ASoC: soc-pcm: cleanup d=
pcm_fe_dai_do_trigger()
# good: [7dff18535b93ea1ce6dbaf36b7ae670f04113d08] phy: PHY_LAN966X_SERDES =
should depend on SOC_LAN966 || MCHP_LAN966X_PCI
# good: [3df75289ddc28b46121d51d2812943b78676497b] soundwire: amd: add soun=
dwire host wake interrupt enable/disable sequence
# good: [d2317767723b63d28e3b93da92760b7934935536] phy: samsung-ufs: suppor=
t ExynosAutov920 ufs phy driver
# good: [aac2f8363f773ae1f65aab140e06e2084ac6b787] soundwire: slave: fix an=
 OF node reference leak in soundwire slave device
# good: [994719ed6d81a6f4677875ab6730254c0bc484ea] ASoC: Intel: avs: Use st=
r_on_off() in avs_dsp_core_power()
# good: [ae575d2145d1a2c8bb5d2835d7d54751f3b0bace] ASoC: tegra: Remove the =
isomgr_bw APIs export
# good: [e957c96455e8f4c630d5e374312cad0633ca7e17] spi: offload: fix use af=
ter free
# good: [f22ba3561daa792dd138ed543e0bf48efe0b999c] ASoC: SOF: imx-common: s=
et sdev->pdata->hw_pdata after common is alloc'd
# good: [ad0fbcebb5f6e093d433a0873758a2778d747eb8] ASoC: adau1701: use gpio=
d_multi_set_value_cansleep
# good: [ff4d4158ef9143327a42f7be4298751cb0d1be69] spi: spi-offload-trigger=
-pwm: add extra headers
# good: [21aa330fec31bb530a4ef6c9555fb157d0711112] ASoC: fsl_micfil: Add de=
cimation filter bypass mode support
# good: [c5528214c7c0a753c908a7b353309ba665985fb4] ASoC: codecs: wcd93xx-sd=
w: fix of_property_read_bool() warnings
# good: [330cbb40bb3664a18a19760bd6dc6003d6624041] dt-bindings: ASoC: rockc=
hip: Add compatible for RK3588 SPDIF
# good: [5a19e1985d014fab9892348f6175a19143cec810] spi: axi-spi-engine: imp=
lement offload support
# good: [852c0b7204ded184924c41ab99b2ac7a70ad4dab] ASoC: Intel: soc-acpi-in=
tel-ptl-match: add rt713_vb_l2_rt1320_l13
# good: [4bb5b6f13fd83b32c8a93fbd399e7558415d1ce0] ASoC: amd: amd_sdw: Add =
quirks for Dell SKU's
# good: [9da195880f167ab7c2d595388decf783c9920121] ASoC: SDCA: Add support =
for PDE Entity properties
# good: [6cf5df1040ba0694aea6a5edc6f31811a442ea36] ASoC: SOF: imx: add driv=
er for the imx95 chip
# good: [4c7518062d638837cea915e0ffe30f846780639a] ASoC: SOF: ipc4: Add sup=
port for split firmware releases
# good: [cb161c333927142818d6bf22a4da2b023fb2b8c9] ASoC: tas2781: Switch to=
 use %ptTsr
# good: [153dbf4adad0082d030c30d20541df2b1af52db6] regmap: irq: Use one way=
 of setting all bits in the register
# good: [0e9a970d7b2cb98d741bc0e32ad8c8f30c009c63] ASoC: qcom: sdw: Add get=
 and set channel maps support from codec to cpu dais
# good: [583348bd65ceaf4a5067a6267dd236929e1b4b37] ASoC: SOF: ipc4-topology=
: Improve the information in prepare_copier prints
# good: [0a7c85b516830c0bb088b0bdb2f2c50c76fc531a] regulator: ad5398: Fix i=
ncorrect power down bit mask
# good: [215705db51eb23052c73126d2efb6acbc2db0424] spi: Replace custom fsle=
ep() implementation
# good: [6603c5133daadbb3277fbd93be0d0d5b8ec928e8] ASoC: dt-bindings: atmel=
,at91-ssc: Convert to YAML format
# good: [25fac20edd09b60651eabcc57c187b1277f43d08] spi: gpio: Support a sin=
gle always-selected device
# good: [e27c125040b1e1f26d910b46daabbe55e67fdf3b] ASoC: codecs: wcd934x: u=
se wcd934x binding header
# good: [652ffad172d089acb1a20e5fde1b66e687832b06] spi: fsi: Batch TX opera=
tions
# good: [6eab7034579917f207ca6d8e3f4e11e85e0ab7d5] ASoC: soc-core: Stop usi=
ng of_property_read_bool() for non-boolean properties
# good: [856366dc924a9561dae39f252b45dfd6cc6895ce] ALSA: hda: Select avs-dr=
iver by default on MBL
# good: [7e17e80c3a7eb2734795f66ba946f933412d597f] Merge branch 'for-6.14/s=
tack-order' into for-next
git bisect start 'be5c7bbb3a64baf884481a1ba0c2f8fb2f93f7c3' '26ae3358dc4d3d=
fb1c449871840de41ef9ac3aa6' 'be1e3607f29a5a182eaa70e3058aef32fd0cc4f8' '621=
42da241a08006f89b0620f7291e3a08c0a094' '1d2e01d53a8ebfffb49e8cc656f8c852391=
21b26' '55a1abd6e76ce91eb6049f32efec3a8506686748' 'f00b3056843d14754ac1bab2=
106cf5599680f115' '3e7b375752b5e4de56e92dfb9c43309cd985b869' '8fd0e127d8da8=
56e34391399df40b33af2b307e0' '0dffacbbf8d044456d50c893adb9499775c489f4' '18=
77c3e7937fb2b9373ba263a4900448d50917b7' 'a9409fcb979eaff401837b955b234ca1ee=
05fdbd' '10efa807929084a8a1c38655942a3bf83bce587a' '97673ea38a77e42eaafcf51=
81c84f6c8d40b97e7' '375790f18396b2ba706e031b150c58cd37b45a11' 'db305161880a=
024a43f4b1cbafa7a294793d7a9e' '369552fd03f296261023872b8fc983d1fc55c8e9' 'b=
47834ee4485bbdcc6d36f086ff61c3efd8870d4' 'f3bfa0f07976a7996b6dedba21d2e0d16=
4f08ce8' '64899904d6103500ad01be7b763298dc939285ae' '42ae6e2559e63c2d4096b6=
98cd47aaeb974436df' 'cb15abd47806b449e853caf43f41573c4c82fed3' '66d8e76e8e8=
5a30fbf9809837e07e15a8c5ccb8b' 'c8d08464bce947ee060e0174a3f4e87503269d0c' '=
a261d77fec147b9974aacca8ae8f0693feede838' 'c893ee3f95f16fcb98da934d61483d0b=
7d8ed568' 'd1a09c610027e446ed30c21f61c2f2443bf92a3f' '5d9fca12f54d3e25e0252=
1aa8f3ec5d53759b334' 'd5d9e982a0886a1a99a1a8ef5320c57e257b4fb0' 'eca73df072=
715efb5e880514bb8395e0a4e74a59' '4770132f37dbf327d25455d226e54fafbef6a5c4' =
'11ccaa3121119eeff9ab9d537e0cf6be3b10698b' '73dad3ec96ae3f2da947ff0396c2910=
bd73f00a2' '8a1812d040c0059378fe8687d68a8b6a90493de1' 'a927e72925c7a8aa2a1c=
f330c09ce13f4e5b1120' 'b2108fc82a0acda34388bff3e3ee3544013b1623' '3419bdfd8=
8e314bc5f80b02fa4651c81a0a85b57' 'e08fe24c34d37d00e84009f2fb4c35f5978041e6'=
 'd64c4c3d1c578f98d70db1c5e2535b47adce9d07' '42da18e62652b58ba5ecd1524c146b=
202cda9bb7' '7dff18535b93ea1ce6dbaf36b7ae670f04113d08' '3df75289ddc28b46121=
d51d2812943b78676497b' 'd2317767723b63d28e3b93da92760b7934935536' 'aac2f836=
3f773ae1f65aab140e06e2084ac6b787' '994719ed6d81a6f4677875ab6730254c0bc484ea=
' 'ae575d2145d1a2c8bb5d2835d7d54751f3b0bace' 'e957c96455e8f4c630d5e374312ca=
d0633ca7e17' 'f22ba3561daa792dd138ed543e0bf48efe0b999c' 'ad0fbcebb5f6e093d4=
33a0873758a2778d747eb8' 'ff4d4158ef9143327a42f7be4298751cb0d1be69' '21aa330=
fec31bb530a4ef6c9555fb157d0711112' 'c5528214c7c0a753c908a7b353309ba665985fb=
4' '330cbb40bb3664a18a19760bd6dc6003d6624041' '5a19e1985d014fab9892348f6175=
a19143cec810' '852c0b7204ded184924c41ab99b2ac7a70ad4dab' '4bb5b6f13fd83b32c=
8a93fbd399e7558415d1ce0' '9da195880f167ab7c2d595388decf783c9920121' '6cf5df=
1040ba0694aea6a5edc6f31811a442ea36' '4c7518062d638837cea915e0ffe30f84678063=
9a' 'cb161c333927142818d6bf22a4da2b023fb2b8c9' '153dbf4adad0082d030c30d2054=
1df2b1af52db6' '0e9a970d7b2cb98d741bc0e32ad8c8f30c009c63' '583348bd65ceaf4a=
5067a6267dd236929e1b4b37' '0a7c85b516830c0bb088b0bdb2f2c50c76fc531a' '21570=
5db51eb23052c73126d2efb6acbc2db0424' '6603c5133daadbb3277fbd93be0d0d5b8ec92=
8e8' '25fac20edd09b60651eabcc57c187b1277f43d08' 'e27c125040b1e1f26d910b46da=
abbe55e67fdf3b' '652ffad172d089acb1a20e5fde1b66e687832b06' '6eab7034579917f=
207ca6d8e3f4e11e85e0ab7d5' '856366dc924a9561dae39f252b45dfd6cc6895ce' '7e17=
e80c3a7eb2734795f66ba946f933412d597f'
# bad: [be5c7bbb3a64baf884481a1ba0c2f8fb2f93f7c3] Add linux-next specific f=
iles for 20250227
git bisect bad be5c7bbb3a64baf884481a1ba0c2f8fb2f93f7c3
# good: [9ac8655d3c4771913214f5bf772bf20583d502c5] Merge branch 'master' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
git bisect good 9ac8655d3c4771913214f5bf772bf20583d502c5
# good: [b415bae06a9dea4518885389028e149bb2812266] Merge branch 'next' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
git bisect good b415bae06a9dea4518885389028e149bb2812266
# bad: [3a8f85966dfecc8596fdb30e732eb68ff56392c5] Merge branch 'next' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
git bisect bad 3a8f85966dfecc8596fdb30e732eb68ff56392c5
# good: [574024b154d902bfc4c5d3c1eba95de6d5a5b236] Merge branch into tip/ma=
ster: 'x86/platform'
git bisect good 574024b154d902bfc4c5d3c1eba95de6d5a5b236
# good: [cd204cf7aa640961221ceaa15cd90bfc6c270174] Merge branch 'for-next' =
of git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply.git
git bisect good cd204cf7aa640961221ceaa15cd90bfc6c270174
# good: [ed3b9e01ab408ca6cc59ae34d65bedebd0772e5e] Merge branch 'edac-for-n=
ext' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git
git bisect good ed3b9e01ab408ca6cc59ae34d65bedebd0772e5e
# good: [c52f04dbdef4bcdf518e8073eac9568b6e40e88e] Merge branches 'docs.202=
5.02.04a', 'lazypreempt.2025.02.24a', 'misc.2025.02.06a', 'srcu.2025.02.05a=
' and 'torture.2025.02.05a'
git bisect good c52f04dbdef4bcdf518e8073eac9568b6e40e88e
# bad: [11a7d6a1903714e58848ee227da228e90c76b3d8] Merge branch 'kvm-arm64/m=
isc' into kvmarm/next
git bisect bad 11a7d6a1903714e58848ee227da228e90c76b3d8
# good: [8b0b98ebf34d6e6ad68a27109f78f2e153187737] KVM: arm64: Advertise FE=
AT_ECV when possible
git bisect good 8b0b98ebf34d6e6ad68a27109f78f2e153187737
# bad: [a88c7c22447932c9d5e45cd5b45224a8eb8efa40] KVM: selftests: arm64: Te=
st writes to MIDR,REVIDR,AIDR
git bisect bad a88c7c22447932c9d5e45cd5b45224a8eb8efa40
# good: [b4043e7cb78b96dae07c62d3ac527f84010828cd] KVM: arm64: Maintain per=
-VM copy of implementation ID regs
git bisect good b4043e7cb78b96dae07c62d3ac527f84010828cd
# good: [3adaee78306148da5df5d3d655e9a90bf18e9513] KVM: arm64: Allow usersp=
ace to change the implementation ID registers
git bisect good 3adaee78306148da5df5d3d655e9a90bf18e9513
# first bad commit: [a88c7c22447932c9d5e45cd5b45224a8eb8efa40] KVM: selftes=
ts: arm64: Test writes to MIDR,REVIDR,AIDR

--hnaM5YX/Z+WWtRrK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfAzXgACgkQJNaLcl1U
h9Cpowf/Rab2rLXnIqMgSSeYah0gMFWuaFunVS4Q9Hxx9sVyCUlffeOeLH3etm9w
VCnfGLw/5ZCJFd9Le2hBOtCsmwUs+2ESWZ8lB5Qq5NQYG1wOYjPOdLKgUhG4Xhrp
pNeDpFE57RcaGCYhgJ84VCE6izY4337ekNyrkPZ1x6ITbTm5KFZ4P7pEwDpTX8o7
6PryCh2mZ3ufJ4U7xe3PfLB+59jNENgA5K5d5vYQrHgZxgMLbXXizi4zAqsMkc9T
YcuQM2wRszqaIfMj+NoJ1KYx6pTT34YsFqYcI3G2pCPzvsTCb8jc87s+1y0Q9/tb
ucsi1AxrhYJPuf2j4fD2SDkA1jJE5g==
=wiPO
-----END PGP SIGNATURE-----

--hnaM5YX/Z+WWtRrK--

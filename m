From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 00/11] QEMU MTTCG Test cases
Date: Mon, 28 Nov 2016 11:14:48 +0000
Message-ID: <CAFEAcA9JUOHnJL59EuhQ_dEWjt+YjEcu8LGiJ3CSk_7R4J5Efg@mail.gmail.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161128103744.s3wq53xzsxvu5uus@kamzik.brq.redhat.com> <878ts3uac6.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <878ts3uac6.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, MTTCG Devel <mttcg@greensocs.com>, Claudio Fontana <claudio.fontana@huawei.com>, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, Jan Kiszka <jan.kiszka@siemens.com>, Mark Burton <mark.burton@greensocs.com>, Alvise Rigo <a.rigo@virtualopensystems.com>, QEMU Developers <qemu-devel@nongnu.org>, "Emilio G. Cota" <cota@braap.org>, Fedorov Sergey <serge.fdrv@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Pranith Kumar <bobby.prani@gmail.com>, Richard Henderson <rth@twiddle.net>, =?UTF-8?B?S
List-Id: kvmarm@lists.cs.columbia.edu

On 28 November 2016 at 11:12, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
>
> Andrew Jones <drjones@redhat.com> writes:
>> I've skimmed over everything looking at it from a framwork/sytle
>> perspective. I didn't dig in trying to understand the tests though.
>> One general comment, I see many tests introduce MAX_CPUS 8. Why do
>> that? Why not allow all cpus by using NR_CPUS for the array sizes?
>
> Yeah - I can fix those. I wonder what the maximum is with GIC V3?

So large that you don't want to hardcode it as an array size...

thanks
-- PMM

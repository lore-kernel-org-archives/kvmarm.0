From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 00/11] QEMU MTTCG Test cases
Date: Mon, 28 Nov 2016 13:30:54 +0000
Message-ID: <CAFEAcA8-3qHnp1T4bAiUL3NT8fHWik7-8zruyQKGgfADn5xF9w@mail.gmail.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161128103744.s3wq53xzsxvu5uus@kamzik.brq.redhat.com> <878ts3uac6.fsf@linaro.org>
 <CAFEAcA9JUOHnJL59EuhQ_dEWjt+YjEcu8LGiJ3CSk_7R4J5Efg@mail.gmail.com> <20161128115824.hrofgivt2mlfk7fh@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161128115824.hrofgivt2mlfk7fh@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, MTTCG Devel <mttcg@greensocs.com>, Mark Burton <mark.burton@greensocs.com>, Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@siemens.com>, Claudio Fontana <claudio.fontana@huawei.com>, Alvise Rigo <a.rigo@virtualopensystems.com>, QEMU Developers <qemu-devel@nongnu.org>, "Emilio G. Cota" <cota@braap.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Fedorov Sergey <serge.fdrv@gmail.com>, Pranith Kumar <bobby.prani@gmail.com>, =?UTF-8?B?S09OUkFEIEZyw6lkw6lyaWM=?= <fred.konrad@greensocs.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffe
List-Id: kvmarm@lists.cs.columbia.edu

On 28 November 2016 at 11:58, Andrew Jones <drjones@redhat.com> wrote:
> On Mon, Nov 28, 2016 at 11:14:48AM +0000, Peter Maydell wrote:
>> On 28 November 2016 at 11:12, Alex Benn=C3=A9e <alex.bennee@linaro.org> =
wrote:
>> >
>> > Andrew Jones <drjones@redhat.com> writes:
>> >> I've skimmed over everything looking at it from a framwork/sytle
>> >> perspective. I didn't dig in trying to understand the tests though.
>> >> One general comment, I see many tests introduce MAX_CPUS 8. Why do
>> >> that? Why not allow all cpus by using NR_CPUS for the array sizes?
>> >
>> > Yeah - I can fix those. I wonder what the maximum is with GIC V3?
>>
>> So large that you don't want to hardcode it as an array size...
>
> 255 with the gic series, not yet merged.

I was talking about the architectural GICv3 limit, which is larger
than that by many orders of magnitude. For QEMU it looks like
MAX_CPUMASK_BITS is now 288 rather than 255.

thanks
-- PMM
